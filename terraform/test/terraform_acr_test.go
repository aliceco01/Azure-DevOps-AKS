package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformACR(t *testing.T) {
	options := &terraform.Options{
		TerraformDir: "../modules/acr", // Path to the Terraform code you want to test
	}

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, options)

	// Clean up resources with `terraform destroy`
	defer terraform.Destroy(t, options)
}
