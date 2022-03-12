CURRENT_DIR=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: default
default:
	pip install -r requirements-develop.txt
	pip install -e $(PWD)
	pip install -e $(PWD)/src/ashe
	@python -c "import sys; print('\n'.join(sys.path))"

.PHONY: requirements
requirements:
	rm -f requirements.txt
	rm -f requirements-develop.txt
	$(MAKE) requirements.txt
	$(MAKE) requirements-develop.txt

requirements.txt:
	pip-compile -v --output-file requirements.txt requirements.in

requirements-develop.txt: requirements.txt
	pip-compile -v --output-file requirements-develop.txt requirements-develop.in

.PHONY: collectstatic
collectstatic: check
	rm -rf public/static
	rm -rf public/index.html
	env DJANGO_SETTINGS_MODULE=gac.settings.build \
		python src/manage.py \
			collectstatic \
			--verbosity 0 \
			--noinput \
			--clear

.PHONY: runserver
runserver:
	python src/manage.py runserver 0.0.0.0:8000

.PHONY: backend
backend:
	docker-compose run --rm --service-ports --use-aliases backend --shell


.PHONY: build-prod-image
build-prod-image:
	cd src/frontend && make build-prod
	docker build -t \
		registry.gitlab.com/bjvta/gac-motor/backend:production_$(shell git log -1 --pretty=format:"%h") .

.PHONY: build
build:
	cd src/frontend && make build-prod
	docker build -t \
		registry.gitlab.com/bjvta/gac-motor/backend:production_$(shell git log -1 --pretty=format:"%h") .
	docker push \
		registry.gitlab.com/bjvta/gac-motor/backend:production_$(shell git log -1 --pretty=format:"%h")

.PHONY: test
test:
	python src/manage.py test gac.apps.common --settings=gac.settings.test