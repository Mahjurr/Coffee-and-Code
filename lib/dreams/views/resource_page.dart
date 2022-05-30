import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/rounded_button.dart';
import '../presenter/dreams_presenter.dart';
import '../utils/dreams_utils.dart';
import '../utils/app_colors.dart' as AppColors;




class ResourcesPage extends StatefulWidget {
  final UNITSPresenter presenter;

  ResourcesPage (this.presenter, {required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(100, 56),
          child: Hero(
            tag: 'appBar',
            child: AppBar(
              title: Text("Our Favorites"),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      backgroundColor: AppColors.darkBackground,
      resizeToAvoidBottomInset: true,


      body: Center(
        child: ListView(
          shrinkWrap: true,

          children: <Widget>[

            new Container(
              margin: EdgeInsets.all(30.0),
              child: new Card(
                color: Colors.transparent,
                elevation: 400.0,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Image.asset("lib/assests/images/Turk Coffee.jpg",
                      height: 300,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new InkWell(
                          child: new Text('Turkish Coffee',
                            style: TextStyle(
                                color: colorStyle("main"),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          onTap: () => launch('https://www.thespruceeats.com/turkish-coffee-recipe-2355497')
                      ),
                    ),
                    Text('Turkish coffee is a rich, thick, and delightful drink to be enjoyed slowly with good company. It is brewed in a copper coffee pot called a cezve (jez-VEY), made with powder-like ground coffee, and sweetened to the drinkers taste. Click on the title to be taken to the recipe!',
                      style: TextStyle(
                          color: colorStyle("main"),
                          fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),


            new Container(
              margin: EdgeInsets.all(30.0),
              child: new Card(
                color: Colors.transparent,
                elevation: 400.0,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Image.asset("lib/assests/images/M.1.jpg",
                      height: 300,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new InkWell(
                          child: new Text('Iced Caramel Macchiato',
                            style: TextStyle(
                                color: colorStyle("main"),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          onTap: () => launch('https://www.thespruceeats.com/iced-caramel-macchiato-5080057')
                      ),
                    ),
                    Text('A caramel macchiato is a delectable iced coffee treat that you can get at your favorite coffee house, but it is so easy to make at home and costs a fraction of the price. It only takes four simple ingredients (plus ice). You can even try your hand at making your own vanilla syrup and caramel sauce if you wish. Click on the title to be taken to the recipe!',
                      style: TextStyle(
                          color: colorStyle("main"),
                          fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),

            new Container(
              margin: EdgeInsets.all(30.0),
              child: new Card(
                color: Colors.transparent,
                elevation: 400.0,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Image.asset("lib/assests/images/T.1.jpg",
                      height: 300,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new InkWell(
                          child: new Text('Tres Leches Cake Iced Latte',
                            style: TextStyle(
                                color: colorStyle("main"),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          onTap: () => launch('https://www.thespruceeats.com/tres-leches-cake-latte-recipe-5208260')
                      ),
                    ),
                    Text('Were putting cake in your coffee, but not just any cake. Tres leches means three milks in Spanish. The classic Latin American tres leches cake is a sponge cake soaked in evaporated milk, half-and-half (or heavy cream), and sweetened condensed milk. Click on the title to be taken to the recipe!',
                      style: TextStyle(
                          color: colorStyle("main"),
                          fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),

            new Container(
              margin: EdgeInsets.all(30.0),
              child: new Card(
                color: Colors.transparent,
                elevation: 400.0,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Image.asset("lib/assests/images/C.2-1.jpg",
                      height: 300,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new InkWell(
                          child: new Text('Espresso Crème Brûlée',
                            style: TextStyle(
                                color: colorStyle("main"),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          onTap: () => launch('https://www.thespruceeats.com/espresso-creme-brulee-4080532')
                      ),
                    ),
                    Text('This smooth, creamy espresso crème brûlée is made with a perfect caramelized sugar topping. You can use a kitchen torch for the topping, but you may also put the crème brûlée under the broiler. Click on the title to be taken to the recipe!',
                      style: TextStyle(
                          color: colorStyle("main"),
                          fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),

            new Container(
              margin: EdgeInsets.all(30.0),
              child: new Card(
                color: Colors.transparent,
                elevation: 400.0,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Image.asset("lib/assests/images/C.3.jpg",
                      height: 300,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new InkWell(
                          child: new Text('The Perfect Cappuccino',
                            style: TextStyle(
                                color: colorStyle("main"),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          onTap: () => launch('https://www.thespruceeats.com/how-to-make-cappuccinos-766116')
                      ),
                    ),
                    Text('A cappuccino is an Italian coffee drink that is traditionally prepared with equal parts double espresso, steamed milk, and steamed milk foam on top. Cream may be used instead of milk. It is typically smaller in volume than a latte, and has a thicker layer of microfoam. Click on the title to be taken to the recipe!',
                      style: TextStyle(
                          color: colorStyle("main"),
                          fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),

            RoundedButton(
              colour: AppColors.textField,
              title: 'Video Resources',
              onPressed: () {
                Navigator.pushNamed(context, 'video_resources');
              },
            ),

          ],
        ),
      ),
    );

  }
}
