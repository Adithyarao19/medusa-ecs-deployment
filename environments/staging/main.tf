module "core" {
  source       = "../../modules/core-infra"
  region       = var.region
  db_name      = var.db_name
  db_username  = var.db_username
  db_password  = var.db_password
}

module "ecs" {
  source     = "../../modules/ecs-fargate"
  region     = var.region
  vpc_id     = module.core.vpc_id
  subnet_ids = module.core.subnet_ids
  image_tag  = var.image_tag
}
