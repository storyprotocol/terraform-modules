terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [ aws.target ]
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}

