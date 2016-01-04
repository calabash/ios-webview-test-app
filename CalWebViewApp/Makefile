all:
	$(MAKE) ipa
	$(MAKE) ipa-dylib
	$(MAKE) ipa-cal
	$(MAKE) app
	$(MAKE) app-dylib
	$(MAKE) app-cal

clean:
	rm -rf build
	rm -rf Products

	# Legacy
	rm -rf CalWebView*.ipa
	rm -rf CalWebView*.app.dSYM
	rm -rf CalWebView*.app

# Builds an ipa with no Calabash server.
ipa:
	bin/make/ipa.sh Release

# Builds an ipa that loads the Calabash dylib at runtime.
# If code signing fails, you might need to set the signing identity.
# $ CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (8<snip>F)" make ipa-dylib
ipa-dylib:
	bin/make/ipa.sh Debug

# Builds an ipa from the -cal target.
ipa-cal:
	bin/make/ipa-cal.sh

# Builds an app with no Calabash server.
app:
	bin/make/app.sh Release

# Builds an app that loads the Calabash dylib at runtime.
# If code signing fails, you might need to set the signing identity.
# $ CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (8<snip>F)" make app-dylib
app-dylib:
	bin/make/app.sh Debug

# Builds an app from the -cal target.
app-cal:
	bin/make/app-cal.sh

new:
	bundle exec briar install calabash-server
	$(MAKE) app-cal
	bundle exec cucumber

# Publishes CalWebView/page.html on CI @ the end of the world
# Requires ssh access to the remote server
publish-page:
	bin/make/publish-page.sh

