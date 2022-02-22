# Convenience install and run

# Test workflow
test:
	bash run_workflow.sh

# Install Nextflow
install:
	wget -qO- https://get.nextflow.io | bash
	sudo mv nextflow /usr/local/bin/
	pip install nf-core

.PHONY: test
.PHONY: install
