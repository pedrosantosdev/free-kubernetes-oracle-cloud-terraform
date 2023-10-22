variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
}

variable "certificate_email" {
  type = string
  description = "The email address that is going to receive email from lets encrypt"
  default = "example@domain.com"
}

variable "private_key" {
  type        = string
  description = "The SSH public key to use for connecting to oci"
  default     = ""
}