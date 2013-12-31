# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  polygons = []
  selected = 0

  setHighlighted = ->
    this.setOptions(
      fillOpacity: 0.5
      strokeWeight: 2
    )

  removeHighlighted = ->
    if selected != this.title
      this.setOptions(
        fillOpacity: 0.25
        strokeWeight: 0.5
      )

  setListings = ->
    for polygon in polygons
      polygon.setOptions(
        fillOpacity: 0.25
        strokeWeight: 0.5
      )
    this.setOptions(
      fillOpacity: 0.5
      strokeWeight: 2
    )
    selected = this.title
    for area in gon.areas
      if area.id == this.title
        $('#listing_title').html "#{area.name} Listings"
    counter = 0
    $('#wanted').html(
      for wanted in gon.wanteds
        if wanted.area_id == this.title
          "<div class='panel radius'><h5>#{wanted.volume} ac-ft</h5><p>#{wanted.source} | #{wanted.description}</p></div>"
    )
    $('#for_sale').html(
      for for_sale in gon.for_sales
        if for_sale.area_id == this.title
          "<div class='panel radius'><h5>#{for_sale.volume} ac-ft</h5><p>#{for_sale.source} | #{for_sale.description} | #{for_sale.transferable_to}</p></div>"
    )

  displayArea = (doc) ->
    for area in gon.areas
      if doc[0].url == area.kml.url
        doc[0].placemarks[0].polygon.title = area.id
        # console.log doc[0].placemarks[0].polygon.title
        doc[0].placemarks[0].polygon.setOptions(
          fillColor: area.color
          fillOpacity: 0.25
          strokeWeight: 0.5
        )
        doc[0].placemarks[0].polygon.setMap(map)
        google.maps.event.addListener doc[0].placemarks[0].polygon, 'mouseover', setHighlighted
        google.maps.event.addListener doc[0].placemarks[0].polygon, 'mouseout', removeHighlighted
        google.maps.event.addListener doc[0].placemarks[0].polygon, 'click', setListings
        polygons.push doc[0].placemarks[0].polygon

  mapOptions =
    center: new google.maps.LatLng(40.5555, -111.888)
    zoom: 10
    mapTypeId: google.maps.MapTypeId.ROADMAP
  map = new google.maps.Map($("#map_canvas")[0], mapOptions)

  # layer = new google.maps.FusionTablesLayer(
  #   query:
  #     select: "geometry"
  #     from: "1zPKs09ATpEj_LP7Vp9Z58E-pV1j6kGVxbcgv4Sw"
  # )
  # layer.setMap map

  myParser = new geoXML3.parser(
    afterParse: displayArea
    suppressInfoWindows: true
  )
  # myParser.parse "http://water-rights-listing.dev/central.kml"
  # myParser.parse "http://water-rights-listing.dev/north.kml"
  # myParser.parse "http://water-rights-listing.dev/east.kml"
  # myParser.parse "http://water-rights-listing.dev/west.kml"
  # console.log doc.overlays

  for area in gon.areas
    myParser.parse(area.kml.url)
    # printShit "OMG"

