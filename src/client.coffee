https = require 'https'
querystring = require 'qs'
libxml = require 'libxmljs'

Response = require './response'
AuthorizeResponse = require './authorize_response'
UserResponse = require './user_response'

###
  3Scale client API
  Parameter:
    provider_key {String} Required
    default_host {String} Optional
  Example:
    Client = require('3scale').Client
    client = new Client(provider_key, [default_host])
###
#
module.exports = class Client

  constructor: (provider_key, default_host = "su1.3scale.net") ->
    unless provider_key?
      throw new Error("missing provider_key")
    @provider_key = provider_key
    @host = default_host


  ###
    Authorize a application

    Parameters:
      options is a Hash object with the following fields
        app_id Required
        app_key Required
        referrer Optional
        usage Optional
      callback {Function} Is the callback function that receives the Response object which includes `is_success`
              method to determine the status of the response

    Example:
      client.authorize {app_id: '75165984', app_key: '3e05c797ef193fee452b1ddf19defa74'}, (response) ->
        if response.is_success
          # All Ok
        else
         sys.puts "#{response.error_message} with code: #{response.error_code}"

  ###
  authorize: (options, callback) ->
    _self = this
    result = null

    if (typeof options isnt 'object') || (options.app_id is undefined)
      throw "missing app_id"

    url = "/transactions/authorize.xml?"
    query = querystring.stringify options
    query += '&' + querystring.stringify {provider_key: @provider_key}

    req_opts = 
      host:   @host
      port:   443
      path:   url + query
      method: 'GET'
    request = https.request req_opts, (response) ->
      response.setEncoding 'utf8'
      xml = ""
      response.on 'data', (chunk) ->
        xml += chunk

      response.on 'end', ->
        if response.statusCode == 200 || response.statusCode == 409
          callback _self._build_success_authorize_response xml
        else if response.statusCode in [400...409]
          callback _self._build_error_response xml
        else
          throw "[Client::authorize] Server Error Code: #{response.statusCode}"
    request.end()

  ###
    OAuthorize an Application
    Parameters:
      options is a Hash object with the following fields
        app_id Required
        service_id Optional (In case of mmultiple services)
      callback {Function} Is the callback function that receives the Response object which includes `is_success`
              method to determine the status of the response

    Example:
      client.oauth_authorize {app_id: '75165984', (response) ->
        if response.is_success
          # All Ok
        else
         sys.puts "#{response.error_message} with code: #{response.error_code}"

  ###
  oauth_authorize: (options, callback) ->
    _self = this
    if (typeof options isnt 'object')|| (options.app_id is undefined)
      throw "missing app_id"

    url = "/transactions/oauth_authorize.xml?"
    query = querystring.stringify options
    query += '&' + querystring.stringify {provider_key: @provider_key}

    req_opts = 
      host:   @host
      port:   443
      path:   url + query
      method: 'GET'
    request = https.request req_opts, (response) ->
      response.setEncoding 'utf8'
      xml = ""
      response.on 'data', (chunk) ->
        xml += chunk

      response.on 'end', ->
        if response.statusCode == 200 || response.statusCode == 409
          callback _self._build_success_authorize_response xml
        else if response.statusCode in [400...409]
          callback _self._build_error_response xml
        else
          throw "[Client::oauth_authorize] Server Error Code: #{response.statusCode}"
    request.end()

  ###
    Authorize with user_key
    Parameters:
      options is a Hash object with the following fields
        user_key Required
        service_id Optional (In case of mmultiple services)
      callback {Function} Is the callback function that receives the Response object which includes `is_success`
              method to determine the status of the response

    Example:
      client.authorize_with_user_key {user_key: '123456', (response) ->
        if response.is_success
          # All Ok
        else
         sys.puts "#{response.error_message} with code: #{response.error_code}"

  ###
  authorize_with_user_key: (options, callback) ->
    _self = this

    if (typeof options isnt 'object') || (options.user_key is undefined)
      throw "missing user_key"

    url = "/transactions/authorize.xml?"
    query = querystring.stringify options
    query += '&' + querystring.stringify {provider_key: @provider_key}

    req_opts = 
      host:   @host
      port:   443
      path:   url + query
      method: 'GET'
    request = https.request req_opts, (response) ->
      response.setEncoding 'utf8'
      xml = ""
      response.on 'data', (chunk) ->
        xml += chunk

      response.on 'end', ->
        if response.statusCode == 200 || response.statusCode == 409
          callback _self._build_success_authorize_response xml
        else if response.statusCode in [400...409]
          callback _self._build_error_response xml
        else
          throw "[Client::authorize_with_user_key] Server Error Code: #{response.statusCode}"
    request.end()

  ###
    Authorize and Report in single call
      options is a Hash object with the following fields
        app_id Required
        app_key, user_id, object, usage, no-body, service_id Optional 
      callback {Function} Is the callback function that receives the Response object which includes `is_success`
              method to determine the status of the response

    Example:
      client.authrep {app_id: '75165984', (response) ->
        if response.is_success
          # All Ok
        else
         sys.puts "#{response.error_message} with code: #{response.error_code}"

  ###
  authrep: (options, callback) ->
    _self = this
    if (typeof options isnt 'object') || (options.app_id is undefined)
      throw "missing app_id"

    url = "/transactions/authrep.xml?"
    query = querystring.stringify options
    query += '&' + querystring.stringify {provider_key: @provider_key}

    req_opts = 
      host:   @host
      port:   443
      path:   url + query
      method: 'GET'
    request = https.request req_opts, (response) ->
      response.setEncoding 'utf8'
      xml = ""
      response.on 'data', (chunk) ->
        xml += chunk

      response.on 'end', ->
        if response.statusCode == 200 || response.statusCode == 409
          callback _self._build_success_authorize_response xml
        else if response.statusCode in [400...409]
          callback _self._build_error_response xml
        else
          throw "[Client::authrep] Server Error Code: #{response.statusCode}"
    request.end()

  ###
    Authorize and Report with :user_key

  ###
  authrep_with_user_key: (options, callback) ->
    _self = this
    if (typeof options isnt 'object') || (options.user_key is undefined)
      throw "missing user_key"

    url = "/transactions/authrep.xml?"
    query = querystring.stringify options
    query += '&' + querystring.stringify {provider_key: @provider_key}

    req_opts = 
      host:   @host
      port:   443
      path:   url + query
      method: 'GET'
    request = https.request req_opts, (response) ->
      response.setEncoding 'utf8'
      xml = ""
      response.on 'data', (chunk) ->
        xml += chunk

      response.on 'end', ->
        if response.statusCode == 200 || response.statusCode == 409
          callback _self._build_success_authorize_response xml
        else if response.statusCode in [400...409]
          callback _self._build_error_response xml
        else
          throw "[Client::authrep_with_user_key] Server Error Code: #{response.statusCode}"
    request.end()  

  ###
    Report transaction(s).

    Parameters:
      trans {Array} each array element contain information of a transaction. That information is in a Hash in the form
      {
        app_id {String} Required
        usage {Hash} Required
        timestamp {String} any string parseable by the Data object
      }
      callback {Function} Function that recive the Response object which include a `is_success` method. Required

    Example:
      trans = [
        { "app_id": "abc123", "usage": {"hits": 1}},
        { "app_id": "abc123", "usage": {"hits": 1000}}
      ]

      client.report trans, (response) ->
        if response.is_success
          # All Ok
        else
         sys.puts "#{response.error_message} with code: #{response.error_code}"


  ###
  report: (trans, callback) ->
    _self = this
    unless trans?
      throw "no transactions to report"

    url = "/transactions.xml"
    query = querystring.stringify({transactions: trans, provider_key: @provider_key}).replace(/\[/g, "%5B").replace(/\]/g, "%5D")

    req_opts = 
      host:    @host
      port:    443
      path:    url
      method:  'POST'
      headers: {"host": @host, "Content-Type": "application/x-www-form-urlencoded", "Content-Length": query.length}
    request = https.request req_opts, (response) ->
      xml = ""
      response.on "data", (data) ->
        xml += data

      response.on 'end', () ->
        if response.statusCode == 202
          response = new Response()
          response.success()
          callback response
        else if response.statusCode == 403
          callback _self._build_error_response xml
    request.write query
    request.end()

  ###
    Signup Express
    Parameters:
      org_name, username, email, password (Required)
      account_plan_id, application_plan_id, service_field_id (Optional)
    Description:
      This request allows to reproduce a sign-up from a buyer in a single API call. It will create an Account, an admin User for the account and one Application with its keys.
      If the plan_id are not passed the default plans will be used instead. You can add additional custome parameters that you define in Fields Definition on your Admin Portal.  
  ###
  signup_express: (options, callback) ->
    _self = this
    if (typeof options isnt 'object') || !options.org_name? || !options.username? || !options.email? || !options.password?
      throw "missing required parameters"

    url = "/admin/api/signup.xml"
    query = querystring.stringify options
    query += '&' + querystring.stringify  {provider_key: @provider_key}
    req_opts =
      host: @host
      port: 443
      path: url
      method: 'POST'
      headers: {"Content-Type": "application/x-www-form-urlencoded", "Content-Length": query.length}
    request = https.request req_opts, (response) ->
      response.setEncoding 'utf8'
      xml = ''
      response.on 'data', (chunk) ->
        xml += chunk
      response.on 'end', () ->
        if response.statusCode == 201
          callback _self._get_userId xml
        else
          callback _self._error_signup xml
    request.write query    
    request.end()

  ###
    Account Delete
    Parameters:
      account_id (Required)
    Description:
      Deletes a buyer account. Deleting an account removes all users, applications, service subscriptions to the account  
  ###
  account_delete: (options, callback) ->
    _self = this
    if (typeof options isnt 'object') || !options.account_id?
      throw "missing account_id"

    url = "/admin/api/accounts/#{options.account_id}.xml"
    query = querystring.stringify {provider_key: @provider_key}
    req_opts =
      host: @host
      port: 443
      path: url
      method: 'DELETE'
      headers: {"Content-Type": "application/x-www-form-urlencoded", "Content-Length": query.length}
    request = https.request req_opts, (response) ->
      response.setEncoding 'utf8'
      xml = ''
      response.on 'data', (chunk) ->
        xml += chunk
      response.on 'end', () ->
        if response.statusCode == 200
          callback xml
        else
          callback xml
    request.write query      
    request.end()        

  ###
    Application Find
    Parameters:
      app_id (Required)    
  ###
  application_find: (options, callback) ->
    _self = this
    if (typeof options isnt 'object') || !options.app_id?
      throw "missing app_id"

    url = "/admin/api/applications/find.xml?"
    query = querystring.stringify options
    query += '&' + querystring.stringify {provider_key: @provider_key}
    req_opts = 
      host: @host
      port: 443
      path: url + query
      method: 'GET'
    request = https.request req_opts, (response) ->
      response.setEncoding  'utf8'
      xml = ''
      response.on 'data', (chunk) ->
        xml += chunk
      response.on 'end', () ->
        if response.statusCode == 200
          callback  _self._get_application_key xml
        else
          callback  _self._error_user_key()
    request.end()

  ###
    User List
  ###
  user_list:  (options, callback) ->
    _self = this
    if(typeof options isnt 'object' or not options.account_id? )
      throw "requires account_id "
    url   =  "/admin/api/accounts/#{options.account_id}/users.xml"
    query =  querystring.stringify {provider_key: @provider_key}
    req_opts = 
      host: @host
      port: 443
      path: url
      method: 'GET'
    request = https.request req_opts, (response) ->
      response.setEncoding  'utf8'
      xml = ''
      response.on 'data', (chunk) ->
        xml += chunk
      response.on 'end', ->
        if response.statusCode is 200
          callback null, _self._get_userId xml
        else
          callback true, null


  ###
    User Update
  ###
  user_update:  (options, callback) ->
    _self = this
    if(typeof options isnt 'object' or not options.account_id? or not options.user_id?)
      throw "requires account_id and user_idsss"
    url   =  "/admin/api/accounts/#{options.account_id}/users/#{options.user_id}.xml"
    query = querystring.stringify options
    query += '&' + querystring.stringify  {provider_key: @provider_key}
    req_opts =
      host: @host
      port: 443
      path: url
      method: 'PUT'
      headers: {"Content-Type": "application/x-www-form-urlencoded", "Content-Length": query.length}
    request = https.request req_opts, (response) ->
      response.setEncoding 'utf8'
      xml = ''
      response.on 'data', (chunk) ->
        xml += chunk
      response.on 'end', () ->
        if response.statusCode == 200
          callback null, xml
        else
          callback true, null
    request.write query    
    request.end()


  # privates methods
  _build_success_authorize_response: (xml) ->
    response = new AuthorizeResponse()
    doc = libxml.parseXml xml
    authorize = doc.get('//authorized').text()
    plan = doc.get('//plan').text()
    
    if authorize is 'true'
      response.success()
    else
      reason = doc.get('//reason').text()
      response.error(reason)

    usage_reports = doc.get '//usage_reports'

    if usage_reports
      for index, usage_report of usage_reports.childNodes()
        do (usage_report) ->
          report =
            period: usage_report.attr('period').value()
            metric: usage_report.attr('metric').value()
            period_start: usage_report.get('period_start').text()
            period_end: usage_report.get('period_end').text()
            current_value: usage_report.get('current_value').text()
            max_value: usage_report.get('max_value').text()
          response.add_usage_reports report
    
    response

  _build_error_response: (xml) ->
    response = new AuthorizeResponse()
    doc = libxml.parseXml xml
    error = doc.get '/error'

    response = new Response()
    response.error error.text(), error.attr('code').value()
    response

  _get_userId: (xml) ->
    response = new UserResponse
    response.get_values xml
    response

  _error_signup: (xml) ->
    response = new UserResponse
    response.errors = true
    response.show_errors xml
    response

  _get_user_key: (xml) ->
    response = new UserResponse
    response.get_user_key xml
    response

  _error_user_key: ->
    response = new UserResponse
    response.errors = true
    response

  _get_application_key: (xml) ->
    response = new UserResponse
    response.get_application_key xml
    response