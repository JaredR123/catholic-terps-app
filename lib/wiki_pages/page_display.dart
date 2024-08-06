import 'package:flutter/material.dart';
import 'page_fetcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

String extractHighestQualityImageUrlFromSrcset(String srcset) {
  // Split the srcset into individual URLs
  final urls = srcset.split(',').map((e) => e.trim()).toList();

  // Extract the last URL from the srcset list
  if (urls.isNotEmpty) {
    final lastUrl = urls.last.split(' ').first; // Get the URL part before any space
    // Ensure the URL starts with 'https://'
    if (lastUrl.startsWith('//')) {
      return 'https:$lastUrl';
    }
    return lastUrl;
  }

  return '';
}

class PageScreen extends StatefulWidget {
  final String title;

  PageScreen({required this.title});

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  late Future<String?> pageContent;

  Future<String?> fetchPageOrChunks(String title) async {
    final content = await fetchPageContent(title);

    if (content != null) {
      return content;
    } else {
      return await fetchChunksContent(title);
    }
  }

  @override
  void initState() {
    super.initState();
    pageContent = fetchPageOrChunks(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<String?>(
        future: pageContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No content available'));
          } else {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HtmlWidget(
                    snapshot.data!,
                    customWidgetBuilder: (element) {
                      if (element.localName == 'img') {
                        var srcset = element.attributes['srcset'] ?? '';
                        var src = extractHighestQualityImageUrlFromSrcset(srcset);

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          color: Colors.black.withOpacity(0.7),
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Center(
                                        child: InteractiveViewer(
                                          child: Image.network(
                                            src,
                                            fit: BoxFit.contain,
                                            filterQuality: FilterQuality.high,
                                            width: MediaQuery.of(context).size.width * 1.5,
                                            height: MediaQuery.of(context).size.height / 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.network(
                            src,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      if (element.localName == 'p') {
                        return Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.grey,
                          child: Text(element.text),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}