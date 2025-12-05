variable "frontend_port" {
  default     = 8080
  description = "Port for the frontend service"
}

variable "lightweight_mode" {
  default     = false
  description = "Used for rapid testing. Set this to true to stand up a simple, lightweight nginx server instead of the full swagstore stack"
}