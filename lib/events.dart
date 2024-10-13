import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';


class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late List events = [];
  late List originalEvents = [];
  bool _isLoading = true; // Add this line

  Future<void> fetchData() async {
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref();
    databaseReference.child('events').once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        List<dynamic> data = event.snapshot.value as List<dynamic>;
        setState(() {
          events = data;
          events.shuffle(Random());
          originalEvents = List.from(events);
          _isLoading = false; // Set loading to false after data is fetched
        });
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false; // Set loading to false even if there's an error
      });
    });
  }

  Future<void> searchEvents(String query) async {
    setState(() {
      if (query.isEmpty) {
        events = List.from(originalEvents);
        return;
      }
      events = originalEvents
          .where((event) => (event['name'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0x00555555),
      body: _isLoading // Check if loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white,)) // Show loading indicator
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                  child: TextField(
                    style: GoogleFonts.poppins(
                        color: const Color.fromARGB(
                            255, 190, 177, 255)), // Set the text color here
                    decoration: InputDecoration(
                      hintText: 'Search Events',
                      hintStyle: GoogleFonts.poppins(
                          color: Colors.white), // Optional: Change hint text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                        child: ClipOval(
                          child: Image.asset(
                            "assets/Logo.png",
                            width: 40.0, // Set the size as needed
                            height: 40.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    onChanged: searchEvents,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: screenHeight * 0.65, // Set height relative to screen size
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showEventDialog(context, events[index]),
                          child: _buildEventCard(context, events[index], screenWidth),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map event, double screenWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(150, 136, 119, 223), // Semi-transparent purple
            Color.fromARGB(150, 50, 15, 223), // Semi-transparent dark blue
          ],
          begin: Alignment.topLeft, // Starting point of the gradient
          end: Alignment.bottomRight, // Ending point of the gradient
        ),
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              event['image'],
              width: screenWidth * 0.2, // Adjust width based on screen size
              height: screenWidth * 0.2, // Keep the image proportional
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(event['name'],
                    style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.emoji_events,
                        size: screenWidth * 0.04, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      event['prize'].toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.date_range_rounded,
                        size: screenWidth * 0.04, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      event['date'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.people_alt_rounded,
                      size: screenWidth * 0.04,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event['team_size'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDialog(BuildContext context, Map event) {
    showDialog(
      context: context,
      builder: (context) {
        double screenWidth =
            MediaQuery.of(context).size.width; // Responsive width
        return SingleChildScrollView(
          child: AlertDialog(
            contentPadding: EdgeInsets.zero, // Remove default padding
            content: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/background_image.jpg', // Path to your background image in assets
                    fit: BoxFit.cover,
                  ),
                  ),
                ),
                
                // Content with a semi-transparent overlay
                Container(
                  padding: const EdgeInsets.all(16), // Add padding for content
                  decoration: BoxDecoration(
                    color:
                        Colors.black.withOpacity(0.7), // Semi-transparent overlay
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          event['name'],
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: screenWidth * 0.06),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipOval(
                        child: Image.network(
                          event['image'],
                          width: screenWidth * 0.2, // Responsive image size
                          height: screenWidth * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        event['description'],
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      _buildEventDetailRow(
                          "Prize Pool", event['prize'].toString()),
                      _buildEventDetailRow("Team Size", event['team_size']),
                      const SizedBox(height: 16),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: _buildTimeline(event['timeline'])),
                      const SizedBox(height: 16),
                      _buildOrganizerContacts(event['organizer_contact']),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _launchURL(event['link']),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 46, 239, 197)),
                        child: Text('Register Now',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.poppins(color: Colors.white)),
        Text(value, style: GoogleFonts.poppins(color: Colors.white)),
      ],
    );
  }

  Widget _buildTimeline(Map timeline) {

    List<MapEntry> sortedTimeline = timeline.entries.toList();
    sortedTimeline.sort((a, b) {
      DateFormat format = DateFormat("MMM dd, yyyy");
      DateTime dateA = format.parse(a.value);
      DateTime dateB = format.parse(b.value);
      return dateA.compareTo(dateB);
    });
    timeline = Map.fromEntries(sortedTimeline);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Timeline", style: GoogleFonts.poppins(color: Colors.white)),
        ...timeline.entries.map((entry) => Text('${entry.key}: ${entry.value}',
            style: GoogleFonts.poppins(color: Colors.white))),
      ],
    );
  }

  Widget _buildOrganizerContacts(Map contacts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Organizer Contacts",
            style: GoogleFonts.poppins(color: Colors.white)),
        ...contacts.entries.map((entry) {
            return GestureDetector(
            onTap: () => _launchPhone(entry.value),
            child: Row(
              children: [
              const Icon(Icons.phone, color: Colors.white),
              const SizedBox(width: 8), // Add some spacing between the icon and text
              Text(entry.key, style: GoogleFonts.poppins(color: Colors.white)),
              ],
            ),
            );
        }),
      ],
    );
  }

  Future<void> _launchPhone(String number) async {
    final url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
