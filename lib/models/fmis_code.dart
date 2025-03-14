class FmisCode {
  final int id;
  String fmisCode;
  String projectId;
  String projectDetail;
  int projectBudget;
  final DateTime createdAt;
  final String createdBy;

  FmisCode({
    this.id = 0,
    required this.fmisCode,
    required this.projectId,
    required this.projectDetail,
    required this.projectBudget,
    required this.createdAt,
    required this.createdBy,
  });

  factory FmisCode.fromMap(Map<String, dynamic> map) {
    return FmisCode(
      id: map['id'],
      fmisCode: map['fmis_code'],
      projectId: map['project_id'],
      projectDetail: map['project_detail'],
      projectBudget: map['project_budget'],
      createdAt: DateTime.parse(map['created_at']),
      createdBy: map['created_by'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fmis_code': fmisCode,
      'project_id': projectId,
      'project_detail': projectDetail,
      'project_budget': projectBudget,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
