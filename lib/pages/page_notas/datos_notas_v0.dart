import 'dart:math';

class NotaDato {
  static Map<String, dynamic> notasCursos = {
    "cursos": [
      {
        "id_curso": "1",
        "nombre_curso": "Comunicación",
        "nombre_abv_curso": "Comu",
        "nota_final": "11",
        "docente": "Eduardo Forga Mesa"
      },
      {
        "id_curso": "2",
        "nombre_curso": "Matemática",
        "nombre_abv_curso": "Mate",
        "nota_final": "13",
        "docente": "Maricarmen Salubre Vaca"
      },
      {
        "id_curso": "3",
        "nombre_curso": "Física",
        "nombre_abv_curso": "Fsc",
        "nota_final": "14",
        "docente": "Melo Nariz Cala"
      },
      {
        "id_curso": "4",
        "nombre_curso": "Sociales",
        "nombre_abv_curso": "Soc",
        "nota_final": "15",
        "docente": "Felipe Casabona"
      },
      {
        "id_curso": "5",
        "nombre_curso": "Ciencias",
        "nombre_abv_curso": "Cie",
        "nota_final": "17",
        "docente": "Juan Palotes"
      },
      {
        "id_curso": "6",
        "nombre_curso": "Relgión",
        "nombre_abv_curso": "Rel",
        "nota_final": "6",
        "docente": "Jorge Serrano"
      },
      {
        "id_curso": "7",
        "nombre_curso": "Hisotria",
        "nombre_abv_curso": "His",
        "nota_final": "11",
        "docente": "Angel Sebastian"
      },
      {
        "id_curso": "8",
        "nombre_curso": "Cívica",
        "nombre_abv_curso": "Civ",
        "nota_final": "19",
        "docente": "Melisa Casimiro"
      },
      {
        "id_curso": "9",
        "nombre_curso": "Lengua extranjera",
        "nombre_abv_curso": "L. ext",
        "nota_final": "20",
        "docente": "Leoncio Canales"
      },
      {
        "id_curso": "10",
        "nombre_curso": "Música",
        "nombre_abv_curso": "Mus",
        "nota_final": "16",
        "docente": "Pancracio Sulca"
      },
      {
        "id_curso": "11",
        "nombre_curso": "Pintura",
        "nombre_abv_curso": "Pin",
        "nota_final": "17",
        "docente": "Guillermo Paredes"
      },
      {
        "id_curso": "12",
        "nombre_curso": "Escritura",
        "nombre_abv_curso": "Esc",
        "nota_final": "18",
        "docente": "Nadia Sánchez Arellano"
      }
    ],
    "periodo_mes": "bimestre",
    "periodo_notas": [
      {
        "nro_periodo": "I",
        "notas_cursos": [
          {
            "id_curso": "1",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 1",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 1",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "2",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 2",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 2",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "3",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "4",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 4",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 4",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "5",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 5",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 5",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "6",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 6",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 6",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "7",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 7",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 7",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "8",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 8",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 8",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "9",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 9",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 9",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "10",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 10",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 10",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "11",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 11",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 11",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "12",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 12",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 12",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "nro_periodo": "II",
        "notas_cursos": [
          {
            "id_curso": "1",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 1",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 1",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "2",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 2",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 2",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "3",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "4",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 4",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 4",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "5",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 5",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 5",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "6",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 6",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 6",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "7",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 7",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 7",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "8",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 8",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 8",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "9",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 9",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 9",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "10",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 10",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 10",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "11",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 11",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 11",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "12",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 12",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 12",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "nro_periodo": "III",
        "notas_cursos": [
          {
            "id_curso": "1",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 1",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 1",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "2",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 2",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 2",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "3",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "4",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 4",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 4",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "5",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 5",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 5",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "6",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 6",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 6",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "7",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 7",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 7",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "8",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 8",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 8",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "9",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 9",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 9",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "10",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 10",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 10",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "11",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 11",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 11",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "12",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 12",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 12",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "nro_periodo": "IV",
        "notas_cursos": [
          {
            "id_curso": "1",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 1",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 1",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "2",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 2",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 2",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "3",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 3",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "4",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 4",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 4",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "5",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 5",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 5",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "6",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 6",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 6",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "7",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 7",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 7",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "8",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 8",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 8",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "9",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 9",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 9",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "10",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 10",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 10",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "11",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 11",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 11",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          },
          {
            "id_curso": "12",
            "nota_periodo": "${Random().nextInt(20)}",
            "unidades": [
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la materia 12",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              },
              {
                "nota_unidad": "${Random().nextInt(20)}",
                "descripcion_unidad": "Comprende la clase 12",
                "competencias": [
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  },
                  {
                    "nota_competencia": "${Random().nextInt(20)}",
                    "descripcion_competencia":
                        "Explica, a través de las pruebas de verificación ${Random().nextInt(20)}"
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  };
}
