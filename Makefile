# Convenience install and run
# Install Nextflow
install:
	wget -qO- https://get.nextflow.io | bash
	sudo mv nextflow /usr/local/bin/
	pip install nf-core

# Test workflow
test:
	bash run_workflow.sh

.PHONY: test
.PHONY: install
