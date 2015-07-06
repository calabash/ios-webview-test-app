all:
	$(MAKE) ipa
	$(MAKE) ipa-cal
	$(MAKE) app
	$(MAKE) app-cal

clean:
	rm -rf build
	rm -rf CalWebView.ipa
	rm -rf CalWebView.app.dSYM
	rm -rf CalWebView.app
	rm -rf CalWebView-cal.app
	rm -rf CalWebView-cal.app.dSYM

# Builds an ipa with no Calabash server.
ipa:
	rm -rf build
	./build-ipa.sh Release

# Builds an ipa that loads the Calabash dylib at runtime.
ipa-dylib:
	rm -rf build
	rm -rf CalWebView.ipa
	./build-ipa.sh Debug

# Builds an ipa from the -cal target.
ipa-cal:
	rm -rf build
	./xtc-prepare.sh

# Builds an app with no Calabash server.
app:
	rm -rf build
	rm -rf CalWebView.app
	./build-sim.sh Release

# Builds an app that loads the Calabash dylib at runtime.
app-dylib:
	rm -rf build
	rm -rf CalWebView.app
	./build-sim.sh Debug

# Builds an app from the -cal target.
app-cal:
	rm -rf build
	rm -rf CalWebView-cal.app
	./build-sim-cal.sh

# For project maintainers only.
install_test_binaries:
	$(MAKE) clean
	$(MAKE) all
	./install-test-binaries.rb

new:
	bundle exec briar install calabash-server
	$(MAKE) app-cal
	bundle exec cucumber
