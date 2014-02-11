import 'dart:io';
import 'package:web_ui/component_build.dart';
import 'lib/build_server.dart';


main() {
  run();
}

run() {
  var createServer = new Options().arguments.contains('start-server');
  return buildWithServer((args) {
    var compileToJs = args.contains('dart2js');
    args = args.where((e) => e != 'dart2js' && e != 'start-server').toList();
    args.addAll(['--', '--basedir', '.', '--no-css']);
    return build(args, ['web/slidedeck.html']).then((results) {
      print('Compiling to javascript');
      return Process.run('dart2js',
        ['web/out/web/slidedeck.html_bootstrap.dart',
        '-oweb/out/web/slidedeck.html_bootstrap.dart.js'])
          .then((res) {
            if (res.exitCode == 0) return output;
            return (new StringBuffer()
                ..write(output)
                ..write('\n')
                ..write(res.stdout)
                ..write('\n')
                ..write(res.stderr)).toString();
          });
    });
  }, createServer: createServer);
}
