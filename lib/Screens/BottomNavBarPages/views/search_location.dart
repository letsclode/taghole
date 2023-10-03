import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../../constant/grid.dart';
import '../../../constant/size.dart';
import '../../../provider/location_provider.dart';

class SearchLocationContainerWidget extends StatefulWidget {
  final FloatingSearchBarController controller;
  final Function setOpen;
  final Function(LatLng?) setLatLng;
  final Future Function(LatLng?) setMap;
  final bool disabled;
  const SearchLocationContainerWidget({
    Key? key,
    required this.controller,
    required this.setOpen,
    required this.setLatLng,
    required this.setMap,
    this.disabled = false,
  }) : super(key: key);

  @override
  _SearchLocationContainerWidgetState createState() =>
      _SearchLocationContainerWidgetState();
}

class _SearchLocationContainerWidgetState
    extends State<SearchLocationContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final locationProvider = watch.watch(locationCNP);
      return SizedBox(
        height: widget.disabled ? 80 : null,
        width: double.infinity,
        child: Stack(
          children: [
            FloatingSearchBar(
              backdropColor: Colors.transparent,
              controller: widget.controller,
              hint: 'Select Location',
              height: 50,
              hintStyle: const TextStyle(
                color: Color(0xFF95A8B8),
                fontSize: KXFontSize.small,
              ),
              queryStyle: const TextStyle(
                fontSize: KXFontSize.small,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.white,
              scrollPadding:
                  const EdgeInsets.only(top: KXGrid.small, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              openAxisAlignment: 2.0,
              axisAlignment: 2.0,
              debounceDelay: const Duration(milliseconds: 500),
              leadingActions: const [
                Icon(
                  Icons.location_on_rounded,
                  size: KXGrid.medium,
                ),
              ],
              onQueryChanged: (query) async {
                if (query == '') {
                  widget.setLatLng(null);
                  await widget.setMap(null);
                }

                await locationProvider.fetchAddress(query);
              },
              onFocusChanged: (isFocused) {
                print('test');
                print(isFocused);
                widget.setOpen(isFocused);
                if (widget.controller.query != '') {
                  locationProvider.fetchAddress(widget.controller.query);
                }
              },
              clearQueryOnClose: false,
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                if (!widget.disabled)
                  FloatingSearchBarAction.searchToClear(
                    showIfClosed: false,
                  ),
              ],
              automaticallyImplyBackButton: false,
              automaticallyImplyDrawerHamburger: false,
              builder: (context, transition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Material(
                    color: Colors.white,
                    elevation: 8.0,
                    child: widget.controller.query == ''
                        ? const SizedBox()
                        : widget.controller.query != '' &&
                                locationProvider.searchLocations.isEmpty
                            ? Container(
                                width: double.infinity,
                                color: Colors.white,
                                padding: const EdgeInsets.all(KXGrid.small),
                                child: const Text(
                                  'Sorry, no location found.',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: locationProvider.searchLocations.map(
                                  (location) {
                                    return Material(
                                      child: InkWell(
                                        onTap: () async {
                                          final latLng = await locationProvider
                                              .getLatLongByPlaceId(
                                                  location.placeId);

                                          if (latLng != null) {
                                            widget.setLatLng(latLng);
                                            await widget.setMap(latLng);
                                            widget.controller.query = location
                                                .structuredFormatting.mainText;
                                            widget.controller.close();
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(
                                              KXGrid.small),
                                          child: Text(
                                            location
                                                .structuredFormatting.mainText,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                  ),
                );
              },
            ),
            if (widget.disabled)
              Container(
                color: Colors.transparent,
              ),
          ],
        ),
      );
    });
  }
}
