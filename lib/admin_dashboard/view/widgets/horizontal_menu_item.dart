import 'package:flutter/material.dart';
import '../../controllers/menu_controller.dart' as custom;
import 'package:get/get.dart';
import '../../view/widgets/custom_text.dart';

// update background color for option

class HorizontalMenuItem extends StatelessWidget{

  final String itemName;
  final Function()? onTap;

  const HorizontalMenuItem ({
    super.key,
    required this.itemName,
    required this.onTap
  });

 

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width;

    custom.MenuController menuController = custom.MenuController.instance;
    
    // to detct hover and tap gestures
    return InkWell(
      onTap: onTap,
      onHover: (value){
        value?
        menuController.onHover(itemName) //hover -> update name
        : menuController.onHover("not hovering"); // not hover
      },
      child: Obx(()=>
        Container(
          color: menuController.isHovering(itemName)
          ? Color(0xFF5AB2B2)
          : Colors.transparent,
          child:Row(
            children: [
              Visibility(
                //show only if hover / active
                visible: menuController.isHovering(itemName)|| menuController.isActive(itemName),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Container(
                  //indicator bar
                  width: 6,
                  height:40,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: _width /88),
              Padding(
                padding: const EdgeInsets.all(16),
                child: menuController.returnIconFor(itemName),
              ),

              if(!menuController.isActive(itemName))
                Flexible(
                  child: CustomText(
                    text: itemName,
                    color: menuController.isHovering(itemName)
                    ? const Color(0xFF002B36)
                    : Colors.white),
                )
              else
                Flexible(
                  child: CustomText(
                    text: itemName, 
                    color: Colors.white, 
                    size: 18, 
                    weight: FontWeight.bold, 
                  ),
                )
                

            ],
          ),
        ),

      ),

    );
  }

}