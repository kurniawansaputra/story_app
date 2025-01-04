import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/components/avatar_name_widget.dart';
import '../../../data/models/responses/storyDetail/story.dart';
import '../../home/components/image_story_widget.dart';

class BodyOfDetail extends StatefulWidget {
  final Story data;

  const BodyOfDetail({
    super.key,
    required this.data,
  });

  @override
  State<BodyOfDetail> createState() => _BodyOfDetailState();
}

class _BodyOfDetailState extends State<BodyOfDetail> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    if (widget.data.lat != null && widget.data.lon != null) {
      final marker = Marker(
        markerId: MarkerId(widget.data.id ?? "default_id"),
        position: LatLng(widget.data.lat!, widget.data.lon!),
        onTap: () {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
                LatLng(widget.data.lat!, widget.data.lon!), 18),
          );
        },
      );
      markers.add(marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              zoom: 18,
              target: widget.data.lat != null && widget.data.lon != null
                  ? LatLng(widget.data.lat!, widget.data.lon!)
                  : const LatLng(-6.256081, 106.618755),
            ),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
          ),
          if (widget.data.lat == null || widget.data.lon == null)
            const Center(
              child: Card.filled(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Location not detected',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 16.0,
                        ),
                        height: 5.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ImageStory(
                              imageUrl: widget.data.photoUrl ?? '',
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            AvatarName(
                              name: widget.data.name ?? '',
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              widget.data.description ?? '',
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
