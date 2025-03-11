package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformHelloWorld(t *testing.T) {
	options := &terraform.Options{
		TerraformDir: "../", // Path to the Terraform code you want to test

		Vars: map[string]interface{}{
			// Variables to pass to our Terraform code
		},

		EnvVars: map[string]string{
			// Environment variables to set for Terraform
		},

		NoColor: true, // Disable colors in Terraform commands
	}

	defer terraform.Destroy(t, options) // Cleanup resources with `terraform destroy` at the end of the test

	terraform.InitAndApply(t, options) // Run `terraform init` and `terraform apply`

	// Add your test assertions here
}