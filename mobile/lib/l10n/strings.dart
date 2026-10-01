import 'package:flutter/material.dart';

import '../state/locale_provider.dart';

// Torna o app inteiro reativo a troca de idioma, do mesmo jeito que o
// Theme.of(context) reage a troca de tema, mesmo dentro de telas
// empilhadas pelo Navigator.
class LocaleScope extends InheritedNotifier<LocaleProvider> {
  const LocaleScope({
    super.key,
    required LocaleProvider notifier,
    required super.child,
  }) : super(notifier: notifier);

  static LocaleProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope não encontrado na árvore de widgets');
    return scope!.notifier!;
  }
}

// Uso: Text(tr(context, 'settings'))
String tr(BuildContext context, String key) {
  final lang = LocaleScope.of(context).languageCode;
  final entry = _strings[key];
  if (entry == null) return key;
  return entry[lang] ?? entry['pt'] ?? key;
}

const Map<String, Map<String, String>> _strings = {
  // Splash / boas-vindas
  'welcome_to_micros': {
    'pt': 'Bem-vindo ao MICROS!',
    'en': 'Welcome to MICROS!',
  },
  'micros_intro_description': {
    'pt':
        'Sistema para identificação de microrganismos e análises laboratoriais.',
    'en': 'System for identifying microorganisms and laboratory analysis.',
  },
  'back': {'pt': 'VOLTAR', 'en': 'BACK'},

  // Home
  'take_photo': {'pt': 'Tirar Foto', 'en': 'Take Photo'},
  'open_gallery': {'pt': 'Abrir Galeria', 'en': 'Open Gallery'},
  'new_identification_upper': {
    'pt': 'IDENTIFICAR ESPÉCIE',
    'en': 'IDENTIFY SPECIES'
  },
  'tap_to_start': {'pt': 'Toque para iniciar', 'en': 'Tap to start'},
  'new_count_upper': {'pt': 'CONTAGEM DE ESPOROS', 'en': 'SPORE COUNT'},

  // Histórico
  'history': {'pt': 'Histórico', 'en': 'History'},
  'all_analyses': {'pt': 'Todas as análises', 'en': 'All analyses'},
  'no_analysis_done': {
    'pt': 'Nenhuma análise realizada',
    'en': 'No analysis performed'
  },
  'no_history_yet': {
    'pt': 'Nenhuma análise ou contagem feita ainda.',
    'en': 'No analysis or count done yet.',
  },
  'history_load_error': {
    'pt':
        'Não foi possível carregar o histórico.\nVerifique se a API está rodando.',
    'en': "Couldn't load history.\nCheck if the API is running.",
  },
  'item_count': {'pt': 'itens', 'en': 'items'},

  // Notificações
  'notifications': {'pt': 'Notificações', 'en': 'Notifications'},
  'identification_complete': {
    'pt': 'Identificação concluída',
    'en': 'Identification complete'
  },
  'count_complete': {'pt': 'Contagem concluída', 'en': 'Count complete'},
  'notifications_load_error': {
    'pt':
        'Não foi possível carregar as notificações.\nVerifique se a API está rodando.',
    'en': "Couldn't load notifications.\nCheck if the API is running.",
  },
  'notifications_empty': {
    'pt': 'Você está em dia!\nSuas próximas análises vão aparecer aqui.',
    'en': "You're all caught up!\nYour next analyses will appear here.",
  },
  'delete_all': {'pt': 'Apagar todas', 'en': 'Delete all'},
  'delete_notifications_title': {
    'pt': 'Apagar notificações',
    'en': 'Delete notifications'
  },
  'delete_notifications_confirm': {
    'pt':
        'Tem certeza que deseja apagar todas as notificações? Essa ação não pode ser desfeita.',
    'en':
        'Are you sure you want to delete all notifications? This action cannot be undone.',
  },
  'cancel': {'pt': 'Cancelar', 'en': 'Cancel'},
  'delete': {'pt': 'Apagar', 'en': 'Delete'},
  'delete_notifications_error': {
    'pt': 'Erro ao apagar notificações',
    'en': 'Error deleting notifications',
  },

  // Perfil
  'profile': {'pt': 'Perfil', 'en': 'Profile'},
  'remove_photo': {'pt': 'Remover foto', 'en': 'Remove photo'},
  'change_photo': {'pt': 'Alterar foto', 'en': 'Change photo'},
  'name': {'pt': 'Nome', 'en': 'Name'},
  'save': {'pt': 'Salvar', 'en': 'Save'},
  'profile_updated': {
    'pt': 'Perfil atualizado com sucesso!',
    'en': 'Profile updated successfully!'
  },
  'photo_removed': {
    'pt': 'Foto de perfil removida com sucesso!',
    'en': 'Profile photo removed successfully!',
  },

  // Configurações
  'settings': {'pt': 'Configurações', 'en': 'Settings'},
  'appearance': {'pt': 'Aparência', 'en': 'Appearance'},
  'dark_theme': {'pt': 'Tema Escuro', 'en': 'Dark Theme'},
  'light_theme': {'pt': 'Tema Claro', 'en': 'Light Theme'},
  'app': {'pt': 'Aplicativo', 'en': 'App'},
  'language': {'pt': 'Idioma', 'en': 'Language'},
  'clear_history': {'pt': 'Limpar Histórico', 'en': 'Clear History'},
  'about': {'pt': 'Sobre', 'en': 'About'},
  'privacy_policy': {'pt': 'Política de Privacidade', 'en': 'Privacy Policy'},
  'portuguese': {'pt': 'Português', 'en': 'Portuguese'},
  'english': {'pt': 'Inglês', 'en': 'English'},

  // Sobre
  'version': {'pt': 'Versão', 'en': 'Version'},
  'developer': {'pt': 'Desenvolvedor', 'en': 'Developer'},
  'collaboration': {'pt': 'Colaboração', 'en': 'Collaboration'},
  'description': {'pt': 'Descrição', 'en': 'Description'},
  'about_description': {
    'pt':
        'O MICROS foi desenvolvido como projeto de Trabalho de Conclusão de Curso (TCC) no curso de Agronomia para apoiar a identificação de espécies e a contagem de fungos micorrízicos utilizando inteligência artificial. O aplicativo busca facilitar análises, incentivar pesquisas e promover o conhecimento sobre esses importantes microrganismos do solo.',
    'en':
        "MICROS was developed as a capstone project for the Agronomy program to support species identification and counting of mycorrhizal fungi using artificial intelligence. The app aims to make analysis easier, encourage research, and promote knowledge about these important soil microorganisms.",
  },

  // Telas "em desenvolvimento"
  'clear_history_intro': {
    'pt':
        'Isso apaga permanentemente todas as análises salvas no seu histórico.',
    'en': 'This permanently deletes every analysis saved in your history.',
  },
  'saved_analyses_count': {'pt': 'análises salvas', 'en': 'saved analyses'},
  'delete_all_history': {
    'pt': 'Apagar todo o histórico',
    'en': 'Delete entire history'
  },
  'delete_history_confirm': {
    'pt':
        'Tem certeza que deseja apagar todo o histórico de análises? Essa ação não pode ser desfeita.',
    'en':
        'Are you sure you want to delete the entire analysis history? This action cannot be undone.',
  },
  'history_deleted': {
    'pt': 'Histórico apagado com sucesso!',
    'en': 'History deleted successfully!'
  },
  'nothing_to_clear': {
    'pt': 'Não há nada para apagar.',
    'en': 'There is nothing to clear.'
  },
  'privacy_intro': {
    'pt':
        'O MICROS é um projeto acadêmico (TCC) em fase beta. Esta página explica, de forma simples, quais dados o app usa e como eles são tratados.',
    'en':
        'MICROS is an academic capstone project (TCC) in beta. This page explains, in simple terms, what data the app uses and how it is handled.',
  },
  'privacy_data_collected_title': {
    'pt': 'Dados que coletamos',
    'en': 'Data we collect'
  },
  'privacy_data_collected_body': {
    'pt':
        'O MICROS coleta as fotos que você tira ou seleciona para análise, o nome e a foto de perfil que você cadastra, e o histórico das suas análises (nome do arquivo, espécie identificada e nível de confiança).',
    'en':
        'MICROS collects the photos you take or select for analysis, the name and profile photo you set up, and your analysis history (file name, identified species, and confidence level).',
  },
  'privacy_data_storage_title': {
    'pt': 'Onde seus dados ficam',
    'en': 'Where your data is stored'
  },
  'privacy_data_storage_body': {
    'pt':
        'Essas informações ficam armazenadas localmente, no banco de dados do próprio aplicativo. Não enviamos suas fotos ou seu histórico para servidores externos ou serviços de nuvem de terceiros.',
    'en':
        "This information is stored locally, in the app's own database. We do not send your photos or history to external servers or third-party cloud services.",
  },
  'privacy_third_party_title': {
    'pt': 'Compartilhamento com terceiros',
    'en': 'Sharing with third parties'
  },
  'privacy_third_party_body': {
    'pt':
        'Atualmente o MICROS não compartilha nenhum dado com serviços de terceiros. O assistente virtual Juliano ainda está em desenvolvimento; quando estiver disponível, esta política será atualizada explicando quais dados ele utiliza.',
    'en':
        'MICROS currently does not share any data with third-party services. The Juliano virtual assistant is still under development; once available, this policy will be updated to explain what data it uses.',
  },
  'privacy_permissions_title': {
    'pt': 'Permissões do dispositivo',
    'en': 'Device permissions'
  },
  'privacy_permissions_body': {
    'pt':
        'O app solicita acesso à câmera e à galeria de fotos apenas para permitir que você capture ou selecione imagens a serem analisadas.',
    'en':
        'The app requests access to the camera and photo gallery only so you can capture or select images to be analyzed.',
  },
  'privacy_not_done_title': {
    'pt': 'O que não fazemos',
    'en': "What we don't do"
  },
  'privacy_not_done_body': {
    'pt':
        'O MICROS não exige cadastro ou login, não coleta sua localização, não exibe anúncios e não utiliza ferramentas de rastreamento ou análise de comportamento.',
    'en':
        "MICROS doesn't require sign-up or login, doesn't collect your location, doesn't show ads, and doesn't use tracking or behavior-analytics tools.",
  },
  'privacy_rights_title': {'pt': 'Seus direitos', 'en': 'Your rights'},
  'privacy_rights_body': {
    'pt':
        'Você pode apagar seu histórico de análises a qualquer momento na tela de Notificações. Por ser um projeto acadêmico em desenvolvimento, dúvidas sobre seus dados podem ser enviadas diretamente ao desenvolvedor.',
    'en':
        'You can delete your analysis history at any time from the Notifications screen. As this is an academic capstone project still in development, questions about your data can be sent directly to the developer.',
  },
  'feature_under_development': {
    'pt': 'Esta funcionalidade está em desenvolvimento.',
    'en': 'This feature is under development.',
  },
  'under_development_title': {
    'pt': 'Em desenvolvimento',
    'en': 'Under development'
  },
  'new_count': {'pt': 'Nova Contagem', 'en': 'New Count'},
  'tap_to_select_image': {
    'pt': 'Toque para selecionar uma imagem',
    'en': 'Tap to select an image',
  },
  'counting_spores': {'pt': 'Contando esporos...', 'en': 'Counting spores...'},
  'spores_found': {'pt': 'Esporos encontrados', 'en': 'Spores found'},
  'report_spore_singular': {
    'pt': 'esporo detectado nesta amostra',
    'en': 'spore detected in this sample',
  },
  'report_spore_plural': {
    'pt': 'esporos detectados nesta amostra',
    'en': 'spores detected in this sample',
  },
  'count_another_image': {
    'pt': 'Contar outra imagem',
    'en': 'Count another image'
  },
  'count_error': {'pt': 'Erro ao contar', 'en': 'Error counting'},

  // Identificação
  'new_identification': {
    'pt': 'Nova Identificação',
    'en': 'New Identification'
  },
  'identifying_image': {
    'pt': 'Identificando imagem...',
    'en': 'Identifying image...'
  },

  // Resultado
  'no_species_identified': {
    'pt': 'Nenhuma espécie identificada com confiança suficiente.',
    'en': 'No species identified with enough confidence.',
  },
  'confidence': {'pt': 'Confiança', 'en': 'Confidence'},

  // Ficha de critérios científicos
  'scientific_criteria_title': {
    'pt': 'Critérios científicos de referência',
    'en': 'Reference scientific criteria'
  },
  'criteria_mode': {'pt': 'Modo de formação', 'en': 'Mode of formation'},
  'criteria_diameter': {'pt': 'Diâmetro do esporo', 'en': 'Spore diameter'},
  'criteria_color': {'pt': 'Cor', 'en': 'Color'},
  'criteria_wall': {'pt': 'Parede do esporo', 'en': 'Spore wall'},
  'criteria_distinctive': {
    'pt': 'Característica distintiva',
    'en': 'Distinctive feature'
  },
  'criteria_disclaimer': {
    'pt':
        'Use como apoio para conferência manual: nem todos os critérios do artigo dá pra confirmar só pela foto (alguns exigem lâmina com o esporo esmagado e reagente de Melzer).',
    'en':
        'Use as support for manual review: not every criterion in the article can be confirmed from the photo alone (some require a crushed-mount slide with Melzer\'s reagent).',
  },
  'criteria_source': {
    'pt':
        'Fonte: Stürmer et al. (2026), Mycorrhiza 36:37 — doi.org/10.1007/s00572-026-01270-7',
    'en':
        'Source: Stürmer et al. (2026), Mycorrhiza 36:37 — doi.org/10.1007/s00572-026-01270-7',
  },

  // Relatório em PDF
  'download_report': {
    'pt': 'Baixar relatório PDF',
    'en': 'Download PDF report'
  },
  'report_title_identification': {
    'pt': 'Relatório de Identificação de Espécie',
    'en': 'Species Identification Report',
  },
  'report_title_count': {
    'pt': 'Relatório de Contagem de Esporos',
    'en': 'Spore Count Report',
  },
  'report_field_file': {'pt': 'Arquivo', 'en': 'File'},
  'report_field_result': {'pt': 'Resultado', 'en': 'Result'},
  'report_image_analyzed': {'pt': 'Imagem analisada', 'en': 'Analyzed image'},
  'report_image_original': {'pt': 'Imagem original', 'en': 'Original image'},
  'report_image_detections': {
    'pt': 'Imagem com detecções',
    'en': 'Image with detections',
  },
  'report_interpretation_identified_prefix': {
    'pt': 'A espécie foi identificada como',
    'en': 'The species was identified as',
  },
  'report_interpretation_identified_suffix': {
    'pt': 'com confiança de',
    'en': 'with a confidence of',
  },
  'report_interpretation_count': {
    'pt': 'Foram identificados',
    'en': 'A total of',
  },
  'report_interpretation_count_suffix': {
    'pt': 'esporos na imagem analisada, com confiança média de',
    'en':
        'spores were identified in the analyzed image, with an average confidence of',
  },
  'report_average_confidence': {
    'pt': 'Confiança média',
    'en': 'Average confidence',
  },

  // Chat Juliano
  'skip': {'pt': 'PULAR', 'en': 'SKIP'},
  'juliano_under_development': {
    'pt':
        'O assistente virtual Juliano ainda está em desenvolvimento e estará disponível em breve.',
    'en':
        'The Juliano virtual assistant is still under development and will be available soon.',
  },
};
