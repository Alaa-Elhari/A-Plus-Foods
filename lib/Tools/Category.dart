import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categorycard extends StatefulWidget {
  final String title;
  final String ImageUrl;

  const Categorycard({
    super.key,
    required this.title,
    required this.ImageUrl,
  });

  @override
  State<Categorycard> createState() => _CategorycardState();
}

class _CategorycardState extends State<Categorycard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: NetworkImage(widget.ImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(children: [
        Align(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              widget.title,
              style: GoogleFonts.robotoFlex(fontSize: 20, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          alignment: Alignment.center,
        ),
      ]),
    );
  }
}
