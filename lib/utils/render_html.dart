import 'package:A.N.R/services/leitor/leitor_get_chapter_content.dart';

class RenderHTML {
  static render(String name, List<ChapterImages> images) {
    String elements = '';

    for (ChapterImages image in images) {
      elements =
          '$elements<img src="${image.legacy}" onerror="this.onerror = null; this.src="${image.avif}"; />';
    }

    return _template
        .replaceAll('{{chapterName}}', name)
        .replaceAll('{{content}}', elements);
  }

  static const String _template = '''
  <!DOCTYPE html>
  <html lang="pt-br">
    <head>
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Book</title>
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }

        body {
          width: 100%;
          min-height: 100vh;
          padding: 24px 0px;
          display: flex;
          flex-direction: column;
        }

        body > div, img {
          width: 100%;
        }

        button {
          width: 100%;
          padding: 16px 24px;
          display: flex;
          align-items: center;
          justify-content: center;
          color:  rgb(33, 150, 243);
          font-size: 16px;
          text-align: center;
          font-weight: 500;
          border: 0;
          outline: none;
          background-color: transparent;
        }

        .separator {
          width: 100%;
          padding: 18px 24px;
          display: flex;
          align-items: center;
          justify-content: center;
        }

        .separator > p {
          color: #fff;
          font-size: 20px;
          text-align: center;
          font-weight: 500;
        }

        #loading {
          width: 100%;
          height: 100vh;
          z-index: 2;

          top: 0;
          left: 0;
          position: absolute;

          display: flex;
          align-items: center;
          justify-content: center;

          backdrop-filter: blur(2.5px);
          background-color: rgba(0, 0, 0, 0.01);
        }

        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }

        .loading-indicator {
          width: 48px;
          height: 48px;

          border: 5px solid rgba(33, 150, 243, 0.2);
          border-top: 5px solid rgb(33, 150, 243);
          border-radius: 50%;

          animation: spin 0.8s linear infinite;
          background-color: transparent;
        }
      </style>
    </head>
    <body>
        <div>
          <div class="separator">
            <p>{{chapterName}}</p>
          </div>
          {{content}}
        </div>
    </body>
  </html>
  ''';
}
