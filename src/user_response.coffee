Response = require './response'
libxmljs = require 'libxmljs'

class UserResponse extends Response

	constructor: () ->
		@uid = ''
		@errors = false
		@error_messages = []
		@app_id = ''
		@user_key = ''
		@account_id  = ''
		@application_key = ''

	get_application_key:	(xml)	->
		doc = libxmljs.parseXml xml
		keys = doc.get '//keys'
		@application_key = keys.get('key').text()
		@account_id = doc.get('user_account_id').text()
		@id = doc.get('id').text()


	get_user_id: (xml) ->
		doc = libxmljs.parseXml xml
		user = doc.get '//user'
		@id = user.get('id').text()

	get_app_id:	(xml) ->
		doc	= libxmljs.parseXml	xml
		application = doc.get '//application'
		@app_id 	= application.get('application_id').text()

	show_errors: (xml) ->
		doc = libxmljs.parseXml xml
		xml_errors = doc.find '//error'
		@errors = true

		for val, error of xml_errors			
			@error_messages.push error.text()
		@errors

	get_user_key:	(xml) ->
		doc	= libxmljs.parseXml	xml
		@user_key = doc.get('user_key').text()

	get_account_id: (xml) ->
		doc = libxmljs.parseXml xml
		account = doc.get "//account"
		@account_id = account.get('id').text()

	get_values:	(xml) ->
		@get_user_id xml
		@get_app_id	xml
		@get_account_id xml
		# @get_user_key xml

	is_success:	(xml) ->
		((@errors == false) && (!!@error_messages))

module.exports = exports = UserResponse