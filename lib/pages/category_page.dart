import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/book_details_page.dart';
import 'package:kitap_dagi/pages/favorites_page.dart';
import 'package:kitap_dagi/pages/login_page.dart';
import 'package:kitap_dagi/pages/profile_page.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  const CategoryPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    CategoryViewModel _categoryModel =
        Provider.of<CategoryViewModel>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text("Kitap Dağı"),
            centerTitle: true,
            elevation: 0,
            actions: [
              Visibility(
                  visible: _userModel.users.durum,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavoritesPage()),
                        );
                      },
                      icon: Icon(Icons.favorite))),
              IconButton(
                  onPressed: () {
                    _userModel.users.durum == false
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilPage()),
                          );
                  },
                  icon: Icon(Icons.person))
            ]),
        drawerEnableOpenDragGesture: true,
        drawer: const MyDrawer(),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              const MyAppBar(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text(
                  this.title,
                  style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: SizedBox(
                  width: 100,
                  child: Divider(
                    color: kPrimaryColor,
                    thickness: 2,
                  ),
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              _categoryModel.state == ViewStatees.geldi
                  ? Kitaplar(context)
                  : Center(child: CircularProgressIndicator()),
            ]))));
  }

  Widget Kitaplar(BuildContext context) {
    CategoryViewModel _categoryModel =
        Provider.of<CategoryViewModel>(context, listen: true);
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 20,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 265,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 290),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  _commentModel
                      .yorumlariGetir(_categoryModel.kitaplar[index].id);
                  _commentModel.yildizPuanla(0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookDetails(
                              book: _categoryModel.kitaplar[index],
                            )),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 207, 207, 207),
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                            _categoryModel.kitaplar[index].bookImage,
                            //"assets/harry.jpg",
                            //height: 190,

                            height: 200,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // book.title,
                              _categoryModel.kitaplar[index].title,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // book.author,
                              _categoryModel.kitaplar[index].author,
                              style: const TextStyle(
                                  color: kPrimaryColor, fontSize: 13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          }),
    );
  }
}
