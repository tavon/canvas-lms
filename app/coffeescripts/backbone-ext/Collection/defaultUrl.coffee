define [
  'use!vendor/backbone'
  'compiled/str/splitAssetString'
], (Backbone, splitAssetString) ->

  ##
  # In the spirit of convention over configuration, if the base API route of your collection
  # follows canvas's default routing pattern of:
  #   /api/v1/<context_type>/<context_id>/<plural_form_of_resource_name>
  # then you can just define a `resourceName` property on your model or collection and fall back on this default
  # 'url' function.  This will look for a @contextCode on your collection and fall back to
  # ENV.context_asset_string.
  #
  # Feel free to still specicically set a url for your collection if you need to do any disambiguation
  #
  # So, for example say you are on /courses/1 and you do new DiscussionTopicsCollection().fetch()
  # it will go to /api/v1/courses/1/discussion_topics (since ENV.context_asset_string will be already set)
  Backbone.Collection::url = ->
    assetString = @contextAssetString || ENV.context_asset_string
    resourceName = @resourceName || @model::resourceName
    throw new Error "Must define a `resourceName` property on collection or model prototype to use defaultUrl" unless resourceName

    [contextType, contextId] = splitAssetString assetString
    "/api/v1/#{contextType}/#{contextId}/#{resourceName}"