MODULES := ./

.PHONY: all
all: init validate fmt lint clean docs

.PHONY: init
init:
	@echo "Initializing Terraform..."
	@for module in $(MODULES); do \
		if [ -d "$$module" ]; then \
			echo "Initializing $$module"; \
			cd $$module && terraform init -backend=false && cd - > /dev/null; \
		fi; \
	done

.PHONY: validate
validate: init
	@echo "Validating Terraform code..."
	@for module in $(MODULES); do \
		if [ -d "$$module" ]; then \
			echo "Validating $$module"; \
			cd $$module && terraform validate && cd - > /dev/null; \
		fi; \
	done

.PHONY: fmt
fmt:
	@echo "Formatting Terraform code..."
	@terraform fmt -recursive

.PHONY: docs
docs:
	@echo "Generating Terraform documentation..."
	@for module in $(MODULES); do \
		if [ -d "$$module" ]; then \
			echo "Generating docs for $$module"; \
			terraform-docs $$module; \
		fi; \
	done

.PHONY: lint
lint: init
	@echo "Linting Terraform code..."
	@for module in $(MODULES); do \
		if [ -d "$$module" ]; then \
			echo "Linting $$module"; \
			cd $$module && tflint && cd - > /dev/null; \
		fi; \
	done

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@for module in $(MODULES); do \
		if [ -d "$$module" ]; then \
			echo "Cleaning $$module"; \
			cd $$module && \
			rm -rf .terraform .terraform.lock.hcl && \
			cd - > /dev/null; \
		fi; \
	done
