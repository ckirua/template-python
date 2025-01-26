PYTHON := python
PIP := pip

# Default target
.DEFAULT_GOAL := help

# Help target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make install     - Install dependencies"
	@echo "  make install-dev - Install development dependencies" 
	@echo "  make build      - Build package"
	@echo "  make build-dev  - Build package with development dependencies"
	@echo "  make test       - Run tests"
	@echo "  make clean      - Clean up temporary files"
	@echo "  make lint       - Run code linting"

.PHONY: install
install:
	$(PIP) install -r requirements.txt
	$(PIP) install .

.PHONY: install-dev
install-dev:
	$(PIP) install -r requirements.txt
	$(PIP) install .

.PHONY: build
build:
	$(PIP) list 2>/dev/null | grep -q build || $(PIP) install build
	$(PYTHON) -m build

.PHONY: build-dev
build-dev:
	$(PIP) list 2>/dev/null | grep -q build || $(PIP) install build
	$(PYTHON) -m build --no-isolation

.PHONY: test
test:
	$(PYTHON) -m pytest tests/

.PHONY: clean
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name "*.egg" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".coverage" -exec rm -rf {} +
	find . -type d -name "build" -exec rm -rf {} +
	find . -type d -name "dist" -exec rm -rf {} +

.PHONY: lint
lint:
	$(PIP) list 2>/dev/null | grep -q black || $(PIP) install black
	$(PIP) list 2>/dev/null | grep -q isort || $(PIP) install isort
	black --check --exclude docs/ .
	isort --check-only --skip docs/ .