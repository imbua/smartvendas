import 'package:flutter/material.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smartvendas/shared/file_handle.dart';
import 'package:smartvendas/shared/page_preview.dart';
import 'package:smartvendas/shared/variaveis.dart';

class PdfInvoice {
  final List<Item> itens;
  final String titulo;
  final Pedido pedido;
  const PdfInvoice(
      {required this.itens, required this.titulo, required this.pedido});

  Future<String> generate(BuildContext context) async {
    final pdf = pw.Document();

    // final iconImage =
    //     (await rootBundle.load('assets/icon.png')).buffer.asUint8List();

    final tableHeaders = [
      'Descrição',
      'Qtd',
      'Valor',
      'Total',
    ];

    final tableData = [[]];

    double total;
    double val;
    double valor;

    // tableData.add([0]);
    total = 0;
    val = 0;
    valor = 0;
    for (var item in itens) {
      if (item.qtde < item.qteminatacado) {
        valor = item.valor;
      } else {
        valor = item.atacado;
        if (valor == 0) {
          valor = item.valor;
        }
      }

      val = valor * item.qtde;
      tableData.add([
        item.descricao,
        formatter.format(item.qtde),
        formatter.format(valor),
        formatter.format(val)
      ]);
      total = total + (val);
      // tableData[0].dd([item.descricao]);
    }

    pdf.addPage(
      pw.MultiPage(
        // header: (context) {
        //   return pw.Text(
        //     'Flutter Approach',
        //     style: pw.TextStyle(
        //       fontWeight: pw.FontWeight.bold,
        //       fontSize: 15.0,
        //     ),
        //   );
        // },
        build: (context) {
          return [
            pw.Row(
              children: [
                // pw.Image(
                //   pw.MemoryImage(iconImage),
                //   height: 72,
                //   width: 72,
                // ),
                pw.SizedBox(width: 1 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.max,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.max,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Text(
                          '$titulo:${pedido.id}',
                          style: pw.TextStyle(
                            fontSize: 17.0,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(width: 50),
                        // pw.Spacer(flex: 2),
                        pw.Text(
                          pedido.datapedido,
                          style: const pw.TextStyle(
                            fontSize: 15.0,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Row(children: [
                      pw.Text(
                        'Vendedor:${pedido.nomevendedor}',
                        style: pw.TextStyle(
                          fontSize: 15.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(width: 50),

                      // pw.Spacer(),
                      pw.Text(
                        'Pgto:${pedido.formapgto}',
                        style: pw.TextStyle(
                          fontSize: 15.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ]),
                    pw.Row(
                      children: [
                        pw.SizedBox(
                          width: 200,
                          child: pw.Text(
                            pedido.nomecliente,
                            style: pw.TextStyle(
                              fontSize: 15.5,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Text(
                          '    CPF/CNPJ${pedido.idcliente}',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.Divider(),
            // pw.SizedBox(height: 1 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///

            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),

            pw.Divider(),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                children: [
                  pw.Spacer(flex: 6),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Total',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              'R\$${formatter.format(total)}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.Row(
              children: [
                pw.Text(
                  'Preço válido para o dia ${pedido.datapedido}',
                ),
              ],
            ),
            pw.SizedBox(
              height: 30,
            ),
            pw.Row(
              children: [
                pw.Text(
                  pedido.observacao,
                ),
              ],
            ),
          ];
        },
        //   footer: (context) {
        //     return pw.Column(
        //       mainAxisSize: pw.MainAxisSize.min,
        //       children: [
        //         pw.Divider(),
        //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
        //         pw.Text(
        //           'Flutter Approach',
        //           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //         ),
        //         pw.SizedBox(height: 1 * PdfPageFormat.mm),
        //         pw.Row(
        //           mainAxisAlignment: pw.MainAxisAlignment.center,
        //           children: [
        //             pw.Text(
        //               'Address: ',
        //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //             ),
        //             pw.Text(
        //               'Merul Badda, Anandanagor, Dhaka 1212',
        //             ),
        //           ],
        //         ),
        //         pw.SizedBox(height: 1 * PdfPageFormat.mm),
        //         pw.Row(
        //           mainAxisAlignment: pw.MainAxisAlignment.center,
        //           children: [
        //             pw.Text(
        //               'Email: ',
        //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //             ),
        //             pw.Text(
        //               'flutterapproach@gmail.com',
        //             ),
        //           ],
        //         ),
        //       ],
        //     );
        //   },
      ),
    );

    final String file =
        await FileHandle.saveDocument(name: 'recibo.pdf', pdf: pdf);

    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PagePreview(inPdfDocFile: file),
        ));
    // Navigator.of(outcontext).pushNamed(AppRoutes.pagePreview, arguments: );
    return file;
  }
}
