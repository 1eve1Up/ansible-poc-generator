.PHONY: init lint syntax test molecule

init:
\tpip install -U pip
\tpip install ansible-core ansible-lint yamllint pre-commit
\t[ -f collections/requirements.yml ] && ansible-galaxy collection install -r collections/requirements.yml || true
\tfor f in roles/*/*/collections/requirements.yml; do [ -f $$f ] && ansible-galaxy collection install -r $$f; done
\tpre-commit install

lint:
\tyamllint -s .
\tansible-lint

syntax:
\tansible-playbook -i localhost, -c local --syntax-check playbooks/**/*.yml

test: lint syntax

molecule:
\tfor d in roles/*/*; do \
\t\tif [ -d $$d/molecule/default ]; then (cd $$d && molecule test) || exit 1; fi; \
\tdone
