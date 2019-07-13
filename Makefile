NAME := nfs

default:
	@echo "please choose a make target..."

release:
	@echo "Checking that VERSION was defined in the calling environment"
	@test -n "$(VERSION)"
	@echo "OK.  VERSION=$(VERSION)"
	git stash
	bosh create-release --final --tarball=releases/$(NAME)-$(VERSION).tgz --name $(NAME) --version $(VERSION)
	git add releases/$(NAME) .final_builds
	git commit -m "Release v$(VERSION)"
	git tag v$(VERSION)
	git stash pop || true
