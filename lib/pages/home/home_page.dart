import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/faq/faqPage.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final TabController tabController;

  HomePage({this.tabController, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationHome,
      actions: [
        AppScaffoldAction(
          icon: Icons.settings,
          tooltip: S.of(context).navigationSettings,
          route: Routes.settings,
        )
      ],
      body: ListView(
        children: [
          profileCard(context),
          favouriteWebsites(context),
          upcomingEvents(context),
          faq(context),
        ],
      ),
    );
  }

  Widget _accountNotVerifiedFooter(BuildContext context) {
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context);

    if (!authProvider.isAuthenticatedFromCache || authProvider.isAnonymous) {
      return Container();
    }

    return FutureBuilder(
      future: authProvider.isVerifiedFromService,
      builder: (BuildContext context, AsyncSnapshot<bool> snap) {
        if (!snap.hasData || snap.data) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
          child: IconText(
            align: TextAlign.center,
            icon: Icons.error_outline,
            text: S.of(context).messageEmailNotVerified,
            actionText: S.of(context).actionSendVerificationAgain,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.w400),
            onTap: () => authProvider.sendEmailVerification(context: context),
          ),
        );
      },
    );
  }

  Widget profileCard(BuildContext context) {
    User user =
        Provider.of<AuthenticationProvider>(context).currentUserFromCache;
    var userName = user.firstName + ' ' + user.lastName;
    var userGroup = user.group;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 40,
                      child: Image(
                          image: AssetImage(
                              'assets/illustrations/undraw_profile_pic.png')),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userName ?? S.of(context).stringAnonymous,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .apply(fontWeightDelta: 2),
                        ),
                        if (userGroup != null)
                          Column(
                            children: [
                              SizedBox(height: 4),
                              Text(userGroup,
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                      ],
                    ),
                  )),
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Theme.of(context).textTheme.button.color,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    ),
                  ),
                ],
              ),
              _accountNotVerifiedFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding favouriteWebsites(BuildContext context) {
    var websites = [
      Website(
        id: '1',
        relevance: null,
        category: WebsiteCategory.learning,
        iconPath: 'icons/websites/moodle.png',
        infoByLocale: {'en': 'info-en', 'ro': 'info-ro'},
        label: 'Moodle',
        link: 'http://acs.curs.pub.ro/',
        isPrivate: false,
      ),
      Website(
        id: '2',
        relevance: null,
        category: WebsiteCategory.learning,
        iconPath: 'icons/websites/ocw.png',
        infoByLocale: {},
        label: 'OCW',
        link: 'https://ocw.cs.pub.ro/',
        isPrivate: false,
      ),
      Website(
        id: '3',
        relevance: null,
        category: WebsiteCategory.administrative,
        iconPath: 'icons/websites/studenti.png',
        infoByLocale: {},
        label: 'studenti',
        link: 'https://studenti.pub.ro/',
        isPrivate: false,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).sectionFrequentlyAccessedWebsites,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () => tabController?.animateTo(2),
                    child: Row(
                      children: <Widget>[
                        Text(
                          S.of(context).actionShowMore,
                          style: Theme.of(context)
                              .accentTextTheme
                              .subtitle2
                              .copyWith(color: Theme.of(context).accentColor),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).accentColor,
                          size: Theme.of(context).textTheme.subtitle2.fontSize,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (isMainUser(context))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: websites
                      .map((website) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder<ImageProvider<dynamic>>(
                                future: Provider.of<StorageProvider>(context,
                                        listen: false)
                                    .imageFromPath(website.iconPath),
                                builder: (context, snapshot) {
                                  ImageProvider<dynamic> image = AssetImage(
                                      'assets/icons/websites/globe.png');
                                  if (snapshot.hasData) {
                                    image = snapshot.data;
                                  }
                                  return CircleImage(
                                    label: website.label,
                                    onTap: () => Utils.launchURL(website.link,
                                        context: context),
                                    image: image,
                                    tooltip: website.infoByLocale[
                                        LocaleProvider.localeString],
                                  );
                                },
                              ),
                            ),
                          ))
                      .toList(),
                ),
              if (!isMainUser(context)) noneYet(context)
            ],
          ),
        ),
      ),
    );
  }

  bool isMainUser(BuildContext context) {
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return authProvider.uid == 'P1Ziec4xuEOjem3NIMWzyTfORTU2';
  }

  Widget noneYet(BuildContext context) => Container(
      height: 100,
      child: Center(
          child: Text(
        S.of(context).warningNoneYet,
        style: TextStyle(color: Theme.of(context).disabledColor),
      )));

  Widget upcomingEvents(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).sectionEventsComingUp,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () => tabController?.animateTo(1),
                    child: Row(
                      children: <Widget>[
                        Text(
                          S.of(context).actionShowMore,
                          style: Theme.of(context)
                              .accentTextTheme
                              .subtitle2
                              .copyWith(color: Theme.of(context).accentColor),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).accentColor,
                          size: Theme.of(context).textTheme.subtitle2.fontSize,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              if (isMainUser(context))
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        ClassHeader(acronym: 'PC').colorFromAcronym,
                    child: Icon(Icons.laptop,
                        color: ClassHeader(acronym: 'PC')
                            .colorFromAcronym
                            .highEmphasisOnColor),
                  ),
                  title: Text('PC - Tema 1'),
                  subtitle: Text('5 Oct 2020 | 23:55'),
                  contentPadding: EdgeInsets.zero,
                ),
              if (isMainUser(context))
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        ClassHeader(acronym: 'USO').colorFromAcronym,
                    child: Icon(Icons.spellcheck,
                        color: ClassHeader(acronym: 'USO')
                            .colorFromAcronym
                            .highEmphasisOnColor),
                  ),
                  title: Text('USO - Test'),
                  subtitle: Text('1 Nov 2020 | 16:00'),
                  contentPadding: EdgeInsets.zero,
                ),
              if (!isMainUser(context)) noneYet(context)
            ],
          ),
        ),
      ),
    );
  }

  Padding faq(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).sectionFAQ,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return FaqPage();
                    })),
                    child: Row(
                      children: <Widget>[
                        Text(
                          S.of(context).actionShowMore,
                          style: Theme.of(context)
                              .accentTextTheme
                              .subtitle2
                              .copyWith(color: Theme.of(context).accentColor),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).accentColor,
                          size: Theme.of(context).textTheme.subtitle2.fontSize,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text('Cum mă conectez la eduroam?'),
                subtitle: Text(
                  'Conectarea în rețeaua eduroam se face pe baza aceluiași cont folosit și pe site-ul de cursuri. Pentru rețeaua eduroam datele de identificare vor fi de forma:',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                title: Text('Care este programul la secretariat?'),
                subtitle: Text(
                  'Secretariatul este deschis în timpul săptămânii între orele 9:00 si 11:00.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
