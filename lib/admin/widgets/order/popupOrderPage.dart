// POPUP FUNCTION
import 'package:flutter/material.dart';
import '../../models/models.dart';



Future<OrderDetail?> showOrderPopup(
  BuildContext context,
  OrderDetail order,
) {
  OrderStatus selectedStatus = order.status;

  return showDialog<OrderDetail>(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {

          return Dialog(
            backgroundColor: Colors.transparent,

            child: Container(
              width: 420,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xfff5f7fb),
                borderRadius:
                    BorderRadius.circular(24),
              ),

          child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // HEADER
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            const Text(
                              "ORDER MANAGEMENT",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              "Order ${order.id}",
                              style:
                                  const TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(
                                context);
                          },
                          icon: const Icon(
                              Icons.close),
                        )
                      ],
                    ),

                    const SizedBox(height: 25),

                    // STATUS
                    Container(
                      padding:
                          const EdgeInsets.all(
                              18),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius
                                .circular(18),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          const Text(
                            "UPDATE ORDER STATUS",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          Row(
                            children: [

                              Expanded(
                                child:
                                    
                                DropdownButton<OrderStatus>(
                                  value: selectedStatus,
                                  isExpanded: true,
                                  items: OrderStatus
                                      .values
                                      .map((status) {
                                    return DropdownMenuItem<
                                        OrderStatus>(
                                      value: status,
                                      child: Text(
                                        status
                                            .name
                                            .toUpperCase(),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged:
                                      (newStatus) {
                                    if (newStatus !=
                                        null) {
                                      setState(() {
                                        selectedStatus =
                                            newStatus;
                                      });
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(
                                  width: 12),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  final updatedOrder = OrderDetail(
                                    order.email,
                                    order.phone,
                                    id: order.id,
                                    customerName: order.customerName,
                                    date: order.date,
                                    coupon: order.coupon,
                                    itemCount: order.itemCount,
                                    totalAmount: order.totalAmount,
                                    status: selectedStatus,
                                    customer: order.customer,
                                    items: order.items,
                                  );
                                  Navigator.pop(context, updatedOrder);
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // CUSTOMER DETAILS
                    const Text(
                      "CUSTOMER DETAILS",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    infoRow(
                      "Full Name",
                      order.customerName,
                    ),

                    infoRow(
                      "Email",
                      order.email,
                    ),

                    infoRow(
                      "Phone",
                      order.phone,
                    ),

                    const SizedBox(height: 24),

                    // ORDER ITEMS
                    Text(
                      "ORDER ITEMS (${order.items.length})",
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Column(
                      children:
                          order.items.map(
                        (item) {

                          return Container(
                            margin:
                                const EdgeInsets
                                    .only(
                              bottom: 12,
                            ),

                            padding:
                                const EdgeInsets
                                    .all(14),

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.white,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          18),
                            ),

                            child: Row(
                              children: [

                                Container(
                                  width: 60,
                                  height: 60,

                                  decoration:
                                      BoxDecoration(
                                    color: Colors
                                        .orange
                                        .shade100,

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                14),
                                  ),

                                  child:
                                      const Icon(
                                    Icons.memory,
                                    color: Colors
                                        .orange,
                                  ),
                                ),

                                const SizedBox(
                                    width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Text(
                                        item.title,
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(
                                          height:
                                              6),

                                      Text(
                                        item.subtitle,
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .grey
                                              .shade600,
                                          fontSize:
                                              12,
                                        ),
                                      ),

                                      const SizedBox(
                                          height:
                                              6),

                                      Text(
                                        "\$${item.price}",
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment:
                          Alignment.centerRight,

                      child: Text(
                        "Total: ${order.totalAmount}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// INFO ROW
Widget infoRow(
  String title,
  String value,
) {
  return Container(
    margin:
        const EdgeInsets.only(bottom: 10),

    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(16),
    ),

    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}