import 'dart:convert';

import 'package:aproxima/Helpers/Choise.dart';
import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Objetos/Secretaria.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class MapaController implements BlocBase {
  List<Protocolo> Protocolos;
  List<Protocolo> filtro = new List();
  List<Protocolo> filtropordata = new List();
  List<Protocolo> filtroporStatus = new List();
  List<Protocolo> filtroporSecretaria = new List();
  bool isFiltering = false;
  bool isFilteringByDate = false;
  bool isFilteringByStatus = false;
  bool isFilteringBySecretaria = false;
  bool showFilters = false;

  DateTime d1;
  DateTime d2;
  Secretaria s;
  Choice c;
  String filtertext;

  List<Secretaria> secretarias;
  BehaviorSubject<List<Secretaria>> _controllerSecretarias =
      new BehaviorSubject<List<Secretaria>>();
  Stream<List<Secretaria>> get outSecretarias => _controllerSecretarias.stream;

  Sink<List<Secretaria>> get inSecretarias => _controllerSecretarias.sink;

  void UpdateFilterBySecretaria(bool b) {
    isFilteringBySecretaria = b;
    inisFilteringBySecretaria.add(isFilteringBySecretaria);
  }

  void UpdateFilterByStatus(bool b) {
    isFilteringByStatus = b;
    inisFilteringByStatus.add(isFilteringByStatus);
  }

  void UpdateShowFilters(bool b) {
    showFilters = b;
    inShowFilters.add(showFilters);
  }

  BehaviorSubject<bool> _controllershowFilters = new BehaviorSubject<bool>();
  Stream<bool> get outshowFilters => _controllershowFilters.stream;

  Sink<bool> get inShowFilters => _controllershowFilters.sink;

  BehaviorSubject<bool> _controllerisFilteringBySecretaria =
      new BehaviorSubject<bool>();
  Stream<bool> get outisFilteringBySecretaria =>
      _controllerisFilteringBySecretaria.stream;

  Sink<bool> get inisFilteringBySecretaria =>
      _controllerisFilteringBySecretaria.sink;

  BehaviorSubject<bool> _controllerisFilteringByStatus =
      new BehaviorSubject<bool>();
  Stream<bool> get outisFilteringByStatus =>
      _controllerisFilteringByStatus.stream;

  Sink<bool> get inisFilteringByStatus => _controllerisFilteringByStatus.sink;

  BehaviorSubject<bool> _controllerIsFilteringByDate =
      new BehaviorSubject<bool>();
  BehaviorSubject<bool> _controllerIsFiltering = new BehaviorSubject<bool>();

  Stream<bool> get outIsFiltering => _controllerIsFiltering.stream;

  Sink<bool> get inIsFiltering => _controllerIsFiltering.sink;
  Stream<bool> get outIsFilteringByDate => _controllerIsFilteringByDate.stream;

  Sink<bool> get inIsFilteringByDate => _controllerIsFilteringByDate.sink;

  BehaviorSubject<List<Protocolo>> _controllerMapa =
      new BehaviorSubject<List<Protocolo>>();

  Stream<List<Protocolo>> get outMapa => _controllerMapa.stream;

  Sink<List<Protocolo>> get inMapa => _controllerMapa.sink;
  @override
  void dispose() {
    _controllerMapa.close();
    _controllerIsFiltering.close();
    _controllerIsFilteringByDate.close();
    _controllerisFilteringByStatus.close();
    _controllerisFilteringBySecretaria.close();
    _controllershowFilters.close();
  }

  MapaController() {
    Fetch();
  }
  Fetch() {
    Protocolos = new List();
    secretarias = new List();
    inIsFiltering.add(isFiltering);
    inIsFilteringByDate.add(isFilteringByDate);
    inisFilteringByStatus.add(isFilteringByStatus);
    inisFilteringBySecretaria.add(isFilteringBySecretaria);
    inShowFilters.add(showFilters);
    //TODO alterar id da cidade de acordo com a cidade do usuario
    http
        .get(
            'http://www.aproximamais.net/webservice/json.php?buscaprotocolocidade=${Helpers.user.cidade.id_cidade}')
        .then((response) {
      var j = json.decode(response.body);
      for (var v in j) {
        if (Helpers.user.permissao >= 2) {
          Protocolos.add(new Protocolo.fromJson(v));
        } else {
          Protocolo p = new Protocolo.fromJson(v);
          if (Helpers.user.id == p.usuario.id) {
            Protocolos.add(p);
          } else {
            if (p.status.descricao != 'Enviado') {
              if (p.status.descricao != 'Excluído') {
                Protocolos.add(p);
              }
            }
          }
        }
      }
      inMapa.add(Protocolos);
    });

    http
        .get(
            'http://www.aproximamais.net/webservice/json.php?buscarsecretarias=true&idcidade=${Helpers.user.cidade.id_cidade}')
        .then((response) {
      var j = json.decode(response.body);
      for (var v in j) {
        Secretaria s = new Secretaria.fromJson(v);
        print('AQUI SECRETARIA ${s.toString()}');
        secretarias.add(s);
      }
      inSecretarias.add(secretarias);
    });
  }

  StartFilter(
      {String filtertext, DateTime d1, DateTime d2, Secretaria s, Choice c}) {
    List<Protocolo> FiltroFinal;
    FiltroFinal = Protocolos;

    if (isFiltering) {
      if (filtertext != null) {
        this.filtertext = filtertext;
      } else {
        filtertext = this.filtertext;
      }
      FiltroFinal = Filter(filtertext, FiltroFinal);
    }

    if (isFilteringByDate) {
      if (d1 == null && d2 == null) {
        d1 = this.d1;
        d2 = this.d2;
      } else {
        this.d1 = d1;
        this.d2 = d2;
      }
      FiltroFinal = FilterByDate(d1, d2, FiltroFinal);
    }
    if (isFilteringByStatus) {
      if (c == null) {
        c = this.c;
      } else {
        this.c = c;
      }
      FiltroFinal = FilterByStatus(c, FiltroFinal);
    }
    if (isFilteringBySecretaria) {
      if (s == null) {
        s = this.s;
      } else {
        this.s = s;
      }
      FiltroFinal = FilterBySecretaria(s, FiltroFinal);
    }
    inMapa.add(FiltroFinal);
  }

  List<Protocolo> Filter(String string, List<Protocolo> lista) {
    filtro = new List();
    for (Protocolo p in lista) {
      if (p.toString().contains(string)) {
        filtro.add(p);
      }
    }
    print(
        "AQUI DEMONIOS PARAMENTRO DE BUSCA >>${string} ${filtro.length} <TAMANHO ${filtro.toString()}");
    return filtro;
  }

  List<Protocolo> FilterByDate(
      DateTime d1, DateTime d2, List<Protocolo> lista) {
    filtropordata = new List();
    for (Protocolo p in lista) {
      if (p.created_at.isBefore(d2) && p.created_at.isAfter(d1)) {
        filtropordata.add(p);
      }
    }
    print(
        "AQUI DEMONIOS PARAMENTRO DE BUSCA >>${d1.toIso8601String()}, ${d2.toIso8601String()} ${filtropordata.length} <TAMANHO ${filtropordata.toString()}");
    UpdateFilterByDate(true);
    return filtropordata;
  }

  List<Protocolo> FilterByStatus(Choice c, List<Protocolo> lista) {
    filtroporStatus = new List();
    for (Protocolo p in lista) {
      if (c.title == 'Todos') {
        filtroporStatus.add(p);
      } else {
        if (p.status.descricao == c.title) {
          filtroporStatus.add(p);
        }
      }
    }
    UpdateFilterByStatus(true);
    return filtroporStatus;
  }

  List<Protocolo> FilterBySecretaria(Secretaria s, List<Protocolo> lista) {
    filtroporSecretaria = new List();
    for (Protocolo p in lista) {
      if (p.secretaria_id != null) {
        if (p.secretaria.id == s.id) {
          filtroporSecretaria.add(p);
        }
      }
    }
    UpdateFilterBySecretaria(true);
    return filtroporSecretaria;
  }

  void UpdateFilter(bool b) {
    isFiltering = b;
    inIsFiltering.add(isFiltering);
  }

  void UpdateFilterByDate(bool b) {
    isFilteringByDate = b;
    inIsFilteringByDate.add(isFilteringByDate);
  }
}
