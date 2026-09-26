import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {

  final int index;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.all(15),

      height: 75,

      decoration: BoxDecoration(

        color: const Color(0xFF1E293B),

        borderRadius: BorderRadius.circular(25),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(.35),
            blurRadius: 15,
          )

        ],

      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [

          item(
            0,
            Icons.history_rounded,
            "Histórico",
          ),

          GestureDetector(

            onTap: (){
              onTap(1);
            },

            child: Container(

              width: 65,

              height: 65,

              decoration: const BoxDecoration(

                color: Color(0xFF22C55E),

                shape: BoxShape.circle,

              ),

              child: const Icon(

                Icons.auto_awesome,

                color: Colors.white,

                size: 32,

              ),

            ),

          ),

          item(
            2,
            Icons.settings_rounded,
            "Config.",
          ),

        ],

      ),

    );

  }

  Widget item(
      int i,
      IconData icon,
      String texto,
      ){

    final ativo = index == i;

    return GestureDetector(

      onTap: (){
        onTap(i);
      },

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(

            icon,

            color: ativo
                ? const Color(0xFF22C55E)
                : Colors.white60,

          ),

          const SizedBox(height:5),

          Text(

            texto,

            style: TextStyle(

              color: ativo
                  ? const Color(0xFF22C55E)
                  : Colors.white60,

              fontSize: 12,

            ),

          ),

        ],

      ),

    );

  }

}