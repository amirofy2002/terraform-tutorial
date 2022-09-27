variable "name" {
	description = "NAME OF VARIBALE"
	default = "api-local-test-terraform-v2"
}

variable "configs" {
  type = object({  
    AWS_USER_TOPIC_ARN = string
  })
}
