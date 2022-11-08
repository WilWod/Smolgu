

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (BuildContext context)  => MyHomePage(title: 'Твое состояние в СМОЛГУ'),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true
      ),

    );
  }
}

//Состояние для основного экрана
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


enum Gender {Man, Woman}

//класс формы
class RegistrationForm{
  String fio = '';
  bool protect = false;
  double Stipendya = 1;
  Gender? gender = Gender.Man;
  List<String> States = <String>['Алкогольного опьянения', 'Адекватном', 'Сонном', 'подавленном'];
  String? State = '';

  RegistrationForm(){
    State = States.first;
  }

}

//Второй экран
class SecondScreen extends StatelessWidget{
  const SecondScreen({super.key, required this.form});

  final RegistrationForm form;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Подведем итоги'),
        ),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),


          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('Ваше ФИО ${form.fio.toString()}'),
                if (form.gender == Gender.Woman)
                  const Text('Вы указали что вы womem')
                else
                  const Text('Вы указали что вы mem'),
                if (form.protect) ... [
                  const Text('К сожалению, Вы ходите Смолгу. Соболезнуем'),
                  Text('Вы хотите стипендию ${form.Stipendya.toInt().toString()} тыс. '),
                  Text('В СмолГУ Вы приходите в состоянни ${form.State.toString()}'),
                  const Text('Возможные состояния'),
                  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: form.States.length,
                      itemBuilder: (BuildContext context, int index){
                        return Text(form.States[index]);
                      }
                  ),
                ]
                else
                  const Text('К Счастью вы не ходите в смолгу.'),




              ]),)
    );
  }
}

//Основной экран
class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();
  RegistrationForm formData = RegistrationForm();
  bool accessData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: 500,
          child: Form(
            key: _formKey,
            onChanged: () {Form.of(primaryFocus!.context!)!.save();},
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration (
                        icon: Icon(Icons.person),
                        labelText: 'ФИО'
                    ),
                    onSaved: (String? value) {
                      if (value != null) {
                        formData.fio = value;
                      }


                    },
                    validator: (String? args) {
                      if (args!.isEmpty) return 'Не введено ФИО.';
                    },

                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child:Align(
                        alignment: Alignment.topLeft,
                        child: Text('Пол'),
                      )),
                  RadioListTile(
                      title: const Text('Мужской'),
                      value: Gender.Man,
                      groupValue: formData.gender,
                      onChanged: (Gender? value) {setState(() {formData.gender = value;});}
                  ),
                  RadioListTile(
                      title: const Text('Женский'),
                      value: Gender.Woman,
                      groupValue: formData.gender,
                      onChanged: (Gender? value) {setState(() {formData.gender = value;});}
                  ),
                  Row(children: [
                    const Text('Приходите ли Вы в СмолГУ?'),
                    Checkbox(
                        value: formData.protect,
                        onChanged: (bool? value) {setState(() {
                          if (value != null) {
                            formData.protect = value;
                          }
                        });}),
                  ]),
                  Row(
                    children: [
                      const Text('Соглашаетесь обучаться без жалоб'),
                      Switch(
                          value: accessData,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null)
                                accessData = value;
                            });
                          }
                      )
                    ],
                  ),
                  if (true) ... [
                    const Text('Выбери в каком состоянии вы приходите в СМОЛГУ'),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: DropdownButton(
                            items: formData.States.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: formData.State,
                            onChanged: (String? value) {setState(() {
                              formData.State = value;
                            });}
                        )
                    ),
                    const Text('Какую стипендию вам хотелось бы? (тыс.)'),
                    Slider(
                      value: formData.Stipendya,
                      onChanged: (double? value) {setState(() {
                        if (value != null) {
                          formData.Stipendya = value;
                        }
                      });},
                      min: 1,
                      max: 6,
                      divisions: 5,
                      label: formData.Stipendya.toInt().toString(),
                    )
                  ],



                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: ElevatedButton(

                          onPressed: () {
                            if (accessData){
                              if(_formKey.currentState!.validate()){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Проверка пройденна'), backgroundColor: Colors.green,));
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SecondScreen(form: formData)));
                              }
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('С жалобами Вам не сюда'), backgroundColor: Colors.red,));
                            }
                          },
                          child: const Text('Проверить форму'))
                  )
                ]
            ),
          )
      ),
    );
  }
}
