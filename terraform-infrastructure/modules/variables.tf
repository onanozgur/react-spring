variable "resource_group_name" {
  default = "react-and-java-rg"
}

variable "location" {
  default = "eastus"
}

variable "vnet_name" {
  default = "react-java-vnet"
}

variable "backend_subnet_name" {
  default = "backend-subnet"
}

variable "frontend_subnet_name" {
  default = "frontend-subnet"
}

variable "app_service_plan_name" {
  default = "react-and-java-plan"
}

variable "backend_app_service_name" {
  default = "java-backend-service"
}

variable "frontend_app_service_name" {
  default = "react-frontend-service"
}

variable "backend_container_image" {
  default = "<your-docker-registry>.azurecr.io/java-backend:latest"
}

variable "frontend_container_image" {
  default = "<your-docker-registry>.azurecr.io/react-frontend:latest"
}

variable "storage_account_name" {
  default = "reactjavastorage"
}

variable "log_analytics_workspace_name" {
  default = "react-java-logs"
}
