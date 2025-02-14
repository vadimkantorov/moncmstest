LEXICALVER = 0.24.0

vanilla: 
	-mv Makefile .Makefile && mv README.md .README.md && rm -rf * && mv .Makefile Makefile && mv .README.md README.md
	curl -L https://github.com/facebook/lexical/archive/refs/tags/v$(LEXICALVER).tar.gz | tar -xzf - --strip-components=1
	npm install rollup
	npm install --prefix packages/lexical-playground --force
	npm run build
	npm run --prefix packages/lexical-playground  build-prod

packages:
	-rm -rf packages
	curl -L https://github.com/facebook/lexical/archive/refs/tags/v$(LEXICALVER).tar.gz | tar -xzf - --strip-components=1 lexical-$(LEXICALVER)/examples/react-rich lexical-$(LEXICALVER)/packages/lexical-playground lexical-$(LEXICALVER)/packages/shared 
	sed -i "s@import moduleResolution from '../shared/viteModuleResolution';@import {viteSingleFile} from "vite-plugin-singlefile"; import * as path from 'node:path';@" packages/lexical-playground/vite.prod.config.ts
	sed -i "s@commonjs(@viteSingleFile(), commonjs(@" packages/lexical-playground/vite.prod.config.ts
	sed -i "s@alias: moduleResolution('production')@alias: [ { find: 'shared', replacement: path.resolve('../shared/src') } ]@" packages/lexical-playground/vite.prod.config.ts
	sed -i "s@split:@//split:@" packages/lexical-playground/vite.prod.config.ts #sed -i "s@split: new URL('./split/index.html', import.meta.url).pathname,@},output: { format: 'iife',/*'es',*/ compact: false, manualChunks: false, inlineDynamicImports: true, entryFileNames: '[name].js',   /* currently does not work for the legacy bundle*/ assetFileNames: '[name].[ext]', /* currently does not work for images*/@" packages/lexical-playground/vite.prod.config.ts

lexicalplaygroundonly:
	#sed -i "s@FigmaEmbedConfig,@@" packages/lexical-playground/src/plugins/AutoEmbedPlugin/index.tsx
	##cp old/indexToolbar.tsx packages/lexical-playground/src/plugins/ToolbarPlugin/index.tsx
	##cp old/indexEditorOnly.tsx packages/lexical-playground/src/indexEditorOnly.tsx
	##sed -i 's@index.tsx@indexEditorOnly.tsx@' packages/lexical-playground/index.html
	#
	npm install terser vite-plugin-singlefile
	npm install --prefix packages/lexical-playground --force
	#npm run --prefix packages/lexical-playground  build-prod
	cd packages/lexical-playground && npm run build-prod
