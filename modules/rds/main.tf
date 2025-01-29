# # Data source for Vault KV secret
# data "vault_kv_secret_v2" "db_secrets" {
#   mount = "secret" 
#   name  = "db"
# }

data "vault_generic_secret" "db_secrets" {
  path = "secret/db"
}

resource "aws_db_instance" "db_instance" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  # username             = data.vault_kv_secret_v2.db_secrets.data["db_username"]
  # password             = data.vault_kv_secret_v2.db_secrets.data["db_password"]
  username             = data.vault_generic_secret.db_secrets.data["db_username"]
  password             = data.vault_generic_secret.db_secrets.data["db_password"]
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true
  publicly_accessible  = true
}

resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = <<EOT
      sleep 120
    EOT
  }

  depends_on = [aws_db_instance.db_instance]
}

resource "null_resource" "update_inventoryc" {
  provisioner "local-exec" {
    command = <<EOT
      bash ./ansible/update_inventory.sh
    EOT
  }

  depends_on = [null_resource.wait]
}

resource "null_resource" "run_ansible_playbook" {
  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook -i ./ansible/inventory.ini ./ansible/db_setup.yml
    EOT
  }

  depends_on = [null_resource.update_inventoryc]
}