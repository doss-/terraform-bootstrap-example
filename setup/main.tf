provider "aws" {
  profile = var.profile
  region  = var.region
}

module "backend" {
  source = "../modules/backend"

  #bootstrap      = "${terraform.workspace == "base" ? 1 : 0}"
  bootstrap      = 1
  operators      = "${local.operators}"
  bucket         = var.bucket
  dynamodb_table = var.dynamodb_table
  key            = var.key
}

resource "local_file" "backend_to_use" {
  filename = "${path.module}/../result-backend.tf"
  content  = templatefile(
    "${path.module}/templates/backend.tftpl", 
    { bucket         = var.bucket,
      dynamodb_table = var.dynamodb_table,
      key            = var.key,              # state file name
      region         = var.region,
      profile        = var.profile
    }
  )
}

resource "local_file" "basic_provider" {
  filename = "${path.module}/../result-provider.tf"
  content  = <<-EOT
provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}
  EOT
}