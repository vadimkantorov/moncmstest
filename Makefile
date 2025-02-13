LEXICALVER = 0.24.0

vanilla: 
	curl -L https://github.com/facebook/lexical/archive/refs/tags/v$(LEXICALVER).tar.gz | tar -xzf - --strip-components=1
	npm install glob
	npm install --prefix packages/lexical-playground --force
	npm run build
	npm run --prefix packages/lexical-playground  build-prod

lexicalplaygroundonly:
	curl -L https://github.com/facebook/lexical/archive/refs/tags/v$(LEXICALVER).tar.gz | tar -xzf - --strip-components=1 lexical-$(LEXICALVER)/packages/lexical-playground lexical-$(LEXICALVER)/packages/shared
	npm install glob
	sed -i "s@FigmaEmbedConfig,@@" packages/lexical-playground/src/plugins/AutoEmbedPlugin/index.tsx
	sed -i "s@import moduleResolution from '../shared/viteModuleResolution';@import * as path from 'node:path';@"               packages/lexical-playground/vite.prod.config.ts
	sed -i "s@alias: moduleResolution('production')@alias: [ { find: 'shared', replacement: path.resolve('../shared/src') } ]@" packages/lexical-playground/vite.prod.config.ts
	#
	##cp indexToolbar.tsx packages/lexical-playground/src/plugins/ToolbarPlugin/index.tsx
	##cp indexEditorOnly.tsx packages/lexical-playground/src/indexEditorOnly.tsx
	##sed -i 's@index.tsx@indexEditorOnly.tsx@' packages/lexical-playground/index.html
	##sed -i "s@split: new URL('./split/index.html', import.meta.url).pathname,@},output: { format: 'iife',/*'es',*/ compact: false, manualChunks: false, inlineDynamicImports: true, entryFileNames: '[name].js',   /* currently does not work for the legacy bundle*/ assetFileNames: '[name].[ext]', /* currently does not work for images*/@" packages/lexical-playground/vite.prod.config.ts
	##sed -i "s@minify: 'terser'@minify: false@" packages/lexical-playground/vite.prod.config.ts
	#
	#npm install --force --prefix packages/lexical-playground @rollup/plugin-babel @babel/plugin-transform-flow-strip-types @babel/preset-react terser
	#npm run --prefix packages/lexical-playground build-prod
	#npm install --force @rollup/plugin-babel @babel/plugin-transform-flow-strip-types @babel/preset-react terser
	npm run build-prod
