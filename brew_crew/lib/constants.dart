import 'package:flutter/material.dart';


const kTextFieldDecoration=InputDecoration(
                hintText: 'Email',
                fillColor: Colors.white,
                filled: true,
                enabledBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white,
                  width: 2,

                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink,width: 2)


                )
                   



              );