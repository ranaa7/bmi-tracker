part of 'bmi_calc_cubit.dart';

@immutable
abstract class BmiCalcState {}

class BmiCalcInitial extends BmiCalcState {}

class BmiCalcLoading extends BmiCalcState {}

class BmiCalcLoaded extends BmiCalcState {
  final double bmi;
  final String status;

 BmiCalcLoaded(this.bmi, this.status);

  @override
  List<Object> get props => [bmi, status];
}

class BmiCalcError extends BmiCalcState {
  final String message;

   BmiCalcError(this.message);

  @override
  List<Object> get props => [message];
}
