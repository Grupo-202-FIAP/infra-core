# Criação do bucket S3
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = var.bucket_name

#   tags = {
#     Name        = "terraform-state"
#     Environment = var.environment
#   }
#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.terraform_state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
#   bucket = aws_s3_bucket.terraform_state.id

 
# Criação do bucket S3 (condicional)
resource "aws_s3_bucket" "terraform_state" {
	count  = var.enable_s3 ? 1 : 0
	bucket = var.bucket_name

	tags = {
		Name        = "terraform-state"
		Environment = var.environment
	}
	lifecycle {
		prevent_destroy = true
	}
}

resource "aws_s3_bucket_versioning" "versioning" {
	count  = var.enable_s3 ? 1 : 0
	bucket = aws_s3_bucket.terraform_state[0].id

	versioning_configuration {
		status = "Enabled"
	}
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
	count  = var.enable_s3 ? 1 : 0
	bucket = aws_s3_bucket.terraform_state[0].id

	rule {
		apply_server_side_encryption_by_default {
			sse_algorithm = "AES256"
		}
	}
}

 
