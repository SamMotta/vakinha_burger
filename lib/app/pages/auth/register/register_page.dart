import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burger/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burger/app/pages/auth/register/register_controller.dart';
import 'package:vakinha_burger/app/pages/auth/register/register_state.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final _registerKey = GlobalKey<FormState>();

  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
          any: hideLoader,
          register: showLoader,
          sucess: () {
            hideLoader();
            showSucess('Usuário cadastrado com sucesso.');
            Navigator.of(context).pop();
          },
          error: () {
            hideLoader();
            showError('Erro ao registrar usuário.');
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppbar(),
        body: SingleChildScrollView(
          child: Form(
            key: _registerKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cadastre-se',
                    style: context.textStyles.textTitle,
                  ),
                  Text(
                    'Preencha os campos abaixo para o seu cadastro.',
                    style: context.textStyles.textMedium.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: Validatorless.required('Nome obrigatório'),
                    controller: _nameEC,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: Validatorless.multiple([
                      Validatorless.required('E-mail obrigatório'),
                      Validatorless.email('E-mail inválido'),
                    ]),
                    controller: _emailEC,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    validator: Validatorless.multiple([
                      Validatorless.required('Senha obrigatória'),
                      Validatorless.min(6, 'Senha deve conter pelo menos 6 caracteres'),
                    ]),
                    controller: _passwordEC,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirmar senha'),
                    validator: Validatorless.multiple([
                      Validatorless.compare(_passwordEC, 'As senhas não são iguais'),
                      Validatorless.min(6, 'Senha deve conter pelo menos 6 caracteres'),
                      Validatorless.required('Senha obrigatória'),
                    ]),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: DeliveryButton(
                      onPressed: () {
                        final valid = _registerKey.currentState?.validate() ?? false;

                        if (valid) {
                          controller.register(
                            _nameEC.text,
                            _emailEC.text,
                            _passwordEC.text,
                          );
                        }
                      },
                      label: 'Cadastrar',
                      width: double.infinity,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
