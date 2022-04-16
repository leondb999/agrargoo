import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/layout_widgets.dart';

class ImpressumPage extends ConsumerStatefulWidget {
  const ImpressumPage({Key? key}) : super(key: key);
  static const routename = '/impressum';

  @override
  _ImpressumPageState createState() => _ImpressumPageState();
}

class _ImpressumPageState extends ConsumerState<ImpressumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context: context, ref: ref, home: false),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar:
            navigationBar(index: 0, context: context, ref: ref, home: false),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.97,
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Impressum",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f623c))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Angaben gem. § 5 TMG:",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("Lara Beutel",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("Coblitzallee 3",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("68163 Mannheim",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Kontaktaufnahme:",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("Telefon: +4927382834",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("Fax: +492034323",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("E-Mail: info@agrago.com",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Umsatzsteuer-ID",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f623c))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Umsatzsteuer-Identifikationsnummer gem. § 27 a Umsatzsteuergesetz:",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("-",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("DE 873 623 110",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text("-",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF000000))),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Haftungsausschluss – Disclaimer:",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f623c))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Haftung für Inhalte",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: Text(
                          "Alle Inhalte unseres Internetauftritts wurden mit größter Sorgfalt und nach bestem Gewissen erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: Text(
                          "Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntniserlangung einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden von den o.g. Rechtsverletzungen werden wir diese Inhalte unverzüglich entfernen.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Haftungsbeschränkung für externe Links",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: Text(
                          "Unsere Webseite enthält Links auf externe Webseiten Dritter. Auf die Inhalte dieser direkt oder indirekt verlinkten Webseiten haben wir keinen Einfluss. Daher können wir für die „externen Links“ auch keine Gewähr auf Richtigkeit der Inhalte übernehmen. Für die Inhalte der externen Links sind die jeweilige Anbieter oder Betreiber (Urheber) der Seiten verantwortlich.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: Text(
                          "Die externen Links wurden zum Zeitpunkt der Linksetzung auf eventuelle Rechtsverstöße überprüft und waren im Zeitpunkt der Linksetzung frei von rechtswidrigen Inhalten. Eine ständige inhaltliche Überprüfung der externen Links ist ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht möglich. Bei direkten oder indirekten Verlinkungen auf die Webseiten Dritter, die außerhalb unseres Verantwortungsbereichs liegen, würde eine Haftungsverpflichtung ausschließlich in dem Fall nur bestehen, wenn wir von den Inhalten Kenntnis erlangen und es uns technisch möglich und zumutbar wäre, die Nutzung im Falle rechtswidriger Inhalte zu verhindern.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: Text(
                          "Diese Haftungsausschlusserklärung gilt auch innerhalb des eigenen Internetauftrittes „Name Ihrer Domain“ gesetzten Links und Verweise von Fragestellern, Blogeinträgern, Gästen des Diskussionsforums. Für illegale, fehlerhafte oder unvollständige Inhalte und insbesondere für Schäden, die aus der Nutzung oder Nichtnutzung solcherart dargestellten Informationen entstehen, haftet allein der Diensteanbieter der Seite, auf welche verwiesen wurde, nicht derjenige, der über Links auf die jeweilige Veröffentlichung lediglich verweist.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: Text(
                          "Werden uns Rechtsverletzungen bekannt, werden die externen Links durch uns unverzüglich entfernt.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Urheberrecht",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Open Sans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      child: Text(
                          "Die auf unserer Webseite veröffentlichen Inhalte und Werke unterliegen dem deutschen Urheberrecht (http://www.gesetze-im-internet.de/bundesrecht/urhg/gesamt.pdf) . Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung des geistigen Eigentums in ideeller und materieller Sicht des Urhebers außerhalb der Grenzen des Urheberrechtes bedürfen der vorherigen schriftlichen Zustimmung des jeweiligen Urhebers i.S.d. Urhebergesetzes (http://www.gesetze-im-internet.de/bundesrecht/urhg/gesamt.pdf ). Downloads und Kopien dieser Seite sind nur für den privaten und nicht kommerziellen Gebrauch erlaubt. Sind die Inhalte auf unserer Webseite nicht von uns erstellt wurden, sind die Urheberrechte Dritter zu beachten. Die Inhalte Dritter werden als solche kenntlich gemacht. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen entsprechenden Hinweis. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Inhalte unverzüglich entfernen.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
