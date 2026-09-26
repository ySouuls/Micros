// Critérios morfológicos oficiais de identificação, extraídos de:
// Stürmer, S.L. et al. (2026) "Dichotomous keys for morphological
// identification of spores produced by arbuscular mycorrhizal fungi
// (phylum Glomeromycota)...". Mycorrhiza 36:37.
// https://doi.org/10.1007/s00572-026-01270-7
//
// Usado só como referência de apoio: a foto sozinha não permite
// confirmar tudo (algumas características só aparecem esmagando o
// esporo numa lâmina com reagente de Melzer).
class EspecieInfo {
  final Map<String, String> modo;
  final Map<String, String> diametro;
  final Map<String, String> cor;
  final Map<String, String> parede;
  final Map<String, String> caracteristica;

  const EspecieInfo({
    required this.modo,
    required this.diametro,
    required this.cor,
    required this.parede,
    required this.caracteristica,
  });
}

const Map<String, EspecieInfo> especiesInfo = {
  'Gigaspora_gigantea': EspecieInfo(
    modo: {'pt': 'Gigasporoide (formado em célula suspensora bulbosa)', 'en': 'Gigasporoid (formed on a bulbous suspensor-like cell)'},
    diametro: {'pt': '240–440 µm', 'en': '240–440 µm'},
    cor: {'pt': 'Amarelo esverdeado brilhante', 'en': 'Bright greenish yellow'},
    parede: {'pt': '2 camadas, sem parede germinativa', 'en': '2 layers, no germinal wall'},
    caracteristica: {
      'pt': 'Camada externa (3,2 µm) e camada laminada interna (17,0 µm)',
      'en': 'Outer layer (3.2 µm) and inner laminated layer (17.0 µm)',
    },
  ),
  'Acaulospora_morrowiae': EspecieInfo(
    modo: {'pt': 'Acaulosporoide (formado a partir de um sáculo esporífero)', 'en': 'Acaulosporoid (formed from a sporiferous saccule)'},
    diametro: {'pt': 'Geralmente acima de 150 µm', 'en': 'Generally above 150 µm'},
    cor: {'pt': 'Hialino a branco a creme pálido a amarelo pardo pálido', 'en': 'Hyaline to white to pale cream to pale yellowish brown'},
    parede: {'pt': '3 camadas, com 1 parede germinativa', 'en': '3 layers, with 1 germinal wall'},
    caracteristica: {
      'pt': 'Camada 2 da parede do esporo com ~2,2 µm de espessura',
      'en': 'Spore wall layer 2 about 2.2 µm thick',
    },
  ),
  'Entrophospora_etunicata': EspecieInfo(
    modo: {'pt': 'Glomoide (formado direto na hifa, sem sáculo)', 'en': 'Glomoid (formed directly on the hypha, no saccule)'},
    diametro: {'pt': 'Em média 102–150 µm', 'en': 'Average 102–150 µm'},
    cor: {'pt': 'Tons de amarelo (pálido a dourado)', 'en': 'Shades of yellow (pale to golden)'},
    parede: {'pt': '2 camadas', 'en': '2 layers'},
    caracteristica: {
      'pt': 'Camada 1 tinge rosa a roxo avermelhado no reagente de Melzer; formado isoladamente no solo (não em cachos)',
      'en': "Layer 1 stains pink to reddish purple in Melzer's reagent; formed singly in the soil (not in clusters)",
    },
  ),
  'Funneliformis_mosseae': EspecieInfo(
    modo: {'pt': 'Glomoide (formado direto na hifa, sem sáculo)', 'en': 'Glomoid (formed directly on the hypha, no saccule)'},
    diametro: {'pt': '100–260 µm', 'en': '100–260 µm'},
    cor: {'pt': 'Tons de amarelo, creme, ocre ou palha', 'en': 'Shades of yellow, cream, ochraceous or straw'},
    parede: {'pt': '2 camadas', 'en': '2 layers'},
    caracteristica: {
      'pt': 'Hifa de sustentação em formato de funil bem aberto — traço bem característico dessa espécie',
      'en': 'Subtending hypha broadly funnel-shaped — a very characteristic trait of this species',
    },
  ),
  'Rhizophagus_clarus': EspecieInfo(
    modo: {'pt': 'Glomoide (formado direto na hifa, sem sáculo)', 'en': 'Glomoid (formed directly on the hypha, no saccule)'},
    diametro: {'pt': '100–260 µm', 'en': '100–260 µm'},
    cor: {'pt': 'Hialino a branco a creme pálido a amarelo pálido', 'en': 'Hyaline to white to pale cream to pale yellow'},
    parede: {'pt': '3 camadas', 'en': '3 layers'},
    caracteristica: {
      'pt': 'Camada 2 da parede (~11,3 µm) tem consistência granular e racha ao secar',
      'en': 'Wall layer 2 (~11.3 µm) has a granular consistency that cracks when dry',
    },
  ),
};
