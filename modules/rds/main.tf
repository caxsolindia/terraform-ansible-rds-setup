resource "aws_db_instance" "db_instance" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true
  publicly_accessible  = true

  # provisioner "local-exec" {
  #   command = "./update_inventory.sh"
  # }

  provisioner "local-exec" {
    command = <<EOT
      echo "Sleeping for 2 minutes to ensure resources are ready..."
      sleep 120
      ./update_inventory.sh
    EOT
  }
}



# resource "aws_db_instance" "db_instance" {
#   allocated_storage    = 10
#   db_name              = var.db_name
#   engine               = var.engine
#   engine_version       = var.engine_version
#   instance_class       = var.instance_class
#   username             = var.username
#   password             = var.password
#   parameter_group_name = "default.postgres14"
#   skip_final_snapshot  = true
#   publicly_accessible  = true

#   # Wait for the DB instance to be ready before executing the provisioner
#   depends_on = [aws_db_instance.db_instance]

#   provisioner "local-exec" {
#     command = <<EOT
#     while true; do
#         DB_ENDPOINT=$(terraform output -raw rds_endpoint 2>/dev/null)
#         if [ ! -z "$DB_ENDPOINT" ]; then
#             ./update_inventory.sh
#             break
#         else
#             echo "Waiting for RDS endpoint to become available..."
#             sleep 30
#         fi
#     done
#     EOT
#   }
# }
