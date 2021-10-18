



import 'dart:io';

class Environment {
   Uri apiUrl(String endpoint) =>    Uri(
                          scheme: 'https',
                          host: 'chat-app-server-nestorcde.herokuapp.com',
                          path: '/api'+endpoint
                        );
   String socketUrl() => 'https://chat-app-server-nestorcde.herokuapp.com';
                      // Uri(
                      //     scheme: 'http',
                      //     host: Platform.isAndroid ? '10.0.2.2' : 'localhost',
                      //     port: 3000,
                      //   );
}