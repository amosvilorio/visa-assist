import 'package:flutter/material.dart';

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agentes Migratorios"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Próximamente:
          // Crear Agente
        },
        icon: const Icon(Icons.person_add),
        label: const Text("Nuevo Agente"),
      ),

      body: Column(
        children: [

          Container(
            margin: const EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar agente...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, index) {

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),

                  child: ListTile(

                    leading: const CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.person),
                    ),

                    title: Text(
                      "Agente ${index + 1}",
                    ),

                    subtitle: const Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 4),

                        Text("Disponible"),

                        Text(
                          "Expedientes activos: 0",
                        ),

                      ],
                    ),

                    trailing: PopupMenuButton(

                      itemBuilder: (_) => [

                        const PopupMenuItem(
                          value: 1,
                          child: Text("Editar"),
                        ),

                        const PopupMenuItem(
                          value: 2,
                          child: Text("Clientes"),
                        ),

                        const PopupMenuItem(
                          value: 3,
                          child: Text("Expedientes"),
                        ),

                        const PopupMenuItem(
                          value: 4,
                          child: Text("Activar"),
                        ),

                        const PopupMenuItem(
                          value: 5,
                          child: Text("Desactivar"),
                        ),

                        const PopupMenuItem(
                          value: 6,
                          child: Text("Suspender"),
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