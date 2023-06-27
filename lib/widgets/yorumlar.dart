import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:provider/provider.dart';


class YorumlarWidget extends StatelessWidget {
  final int baslama;
  const YorumlarWidget({Key? key, required this.baslama}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommentViewModel commentModel =
        Provider.of<CommentViewModel>(context, listen: true);

    Size size = MediaQuery.of(context).size;
    return commentModel.comments.yorumSayisi > 0
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width - 2 * kDefaultPadding,
                          child: const Text(
                            "Yorumlar",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: size.width - 2 * kDefaultPadding,
                          child:const Divider(
                            color: kPrimaryColor,
                            thickness: 2,
                          ),
                        ),
                    const    SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: size.width - 2 * kDefaultPadding,
                          child: ListView.builder(
                              itemCount: commentModel.comments.yorumlar.length -
                                          commentModel.baslama >=
                                      10
                                  ? 10
                                  : commentModel.comments.yorumlar.length -
                                      commentModel.baslama,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                DateTime dt = DateTime.parse(commentModel
                                    .comments.yorumlar[index]["createdAt"]);
                                Intl.defaultLocale = 'tr';
                                String formattedDate =
                                    DateFormat("dd MMMM yyyy").format(dt);
                                return Column(
                                  children: [
                                    Container(
                                      padding:
                                      const    EdgeInsets.all(kDefaultPadding / 2),
                                      decoration: BoxDecoration(
                                          color:const Color.fromARGB(
                                              255, 223, 223, 223),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: size.width -
                                                (2 * kDefaultPadding) -
                                                kDefaultPadding,
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              alignment:
                                                  WrapAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  commentModel.comments
                                                              .yorumlar[index]
                                                          ["nameSurname"] ?? "",
                                                  style: const TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: yildizlar(commentModel
                                                                      .comments
                                                                      .yorumlar[
                                                                  index +
                                                                      baslama]
                                                              ["rank"] !=
                                                          ""
                                                      ? double.parse(
                                                          commentModel.comments
                                                                      .yorumlar[
                                                                  index +
                                                                      baslama]
                                                              ["rank"])
                                                      : 0.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            commentModel.comments
                                                    .yorumlar[index + baslama]
                                                ["title"],
                                            style:const TextStyle(
                                                color: kTextColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(commentModel.comments
                                                  .yorumlar[index + baslama]
                                              ["desc"]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                formattedDate,
                                                style:const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                 const   SizedBox(
                                      height: 10,
                                    )
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }

  Widget yildizlar(num sayi) {
    sayi = sayi.round();
    return Row(
      children: [
        Icon(
          Icons.star,
          color: sayi >= 1 ? Colors.orange : Colors.grey,
        ),
        Icon(
          Icons.star,
          color: sayi >= 2 ? Colors.orange : Colors.grey,
        ),
        Icon(
          Icons.star,
          color: sayi >= 3 ? Colors.orange : Colors.grey,
        ),
        Icon(
          Icons.star,
          color: sayi >= 4 ? Colors.orange : Colors.grey,
        ),
        Icon(
          Icons.star,
          color: sayi >= 5 ? Colors.orange : Colors.grey,
        ),
      ],
    );
  }
}
