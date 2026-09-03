import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar cliente...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (_, index) {

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: ListTile(

                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(
                        Icons.person,
                      ),
                    ),

                    title: Text(
                      "Cliente ${index + 1}",
                    ),

                    subtitle: const Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 4),

                        Text(
                          "Sin agente asignado",
                        ),

                        Text(
                          "0 expedientes",
                        ),

                      ],
                    ),

                    trailing: PopupMenuButton<int>(

                      onSelected: (value) {

                        switch (value) {

                          case 1:
                            break;

                          case 2:
                            break;

                          case 3:
                            break;

                          case 4:
                            break;

                        }

                      },

                      itemBuilder: (_) => const [

                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            "Ver perfil",
                          ),
                        ),

                        PopupMenuItem(
                          value: 2,
                          child: Text(
                            "Asignar agente",
                          ),
                        ),

                        PopupMenuItem(
                          value: 3,
                          child: Text(
                            "Ver expedientes",
                          ),
                        ),

                        PopupMenuItem(
                          value: 4,
                          child: Text(
                            "Ver evaluaciones",
                          ),
                        ),

                      ],
                    ),

                  ),
                );

              },
            ),
          ),

        ],
      ),
    );
  }
}